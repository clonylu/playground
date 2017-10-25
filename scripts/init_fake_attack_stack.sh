ts=$(date +%F_%H-%M-%S)
deployment="$1"
isinit="$2"
[[ -z "$deployment" ]] && echo "Missing arg: deployment" && exit 1

echo "running deployment sync..."
echo "deployment syncing done..."
deployment_sync.py -d $deployment -v
sleep 10 # have to sleep for 10s or configd might be loading corrupted json files... not sure why yet  :'-(

echo "starting configd..."
configd.py -L -v -d "$deployment" > /home/support/logs/configd_"$ts".log 2>&1 &
configd_init_success=1
while [[ ! "configd_init_success" -eq "0" ]]; do
    echo "waiting for configd to be fully initialized..."
    sleep 10
    fgrep -o 'configd-loaded' /home/support/logs/configd_"$ts".log
    configd_init_success="$?"
done

echo "populating sql db..."
if [[ "$isinit" -eq "y" ]]; then
    ddosd.py --init-db -D -d $deployment  # create the database
    metrics.py -D -d $deployment --init  # add metrics
    trigger_groups.py -D -d $deployment --update /home/support/pipedream/conffiles/default_triggers.json # add triggers and trigger groups
fi

echo "starting cubes_from_h5flow..."
cubes_from_h5flow.py --daemon 99 -d "$deployment" -v > /home/support/logs/cubes_from_h5flow_"$ts".log  2>&1 &
echo "starting detect32d..."
detect32d.py -v -D -d "$deployment" --shard 0 > /home/support/logs/detect32d_"$ts".log 2>&1 &
echo "starting incident_aggregator..."
incident_aggregator.py -d "$deployment" -v -D > ~/logs/incident_aggregator_"$ts".log 2>&1 &

echo "done! python processes:"
ps aux | grep 'python'
