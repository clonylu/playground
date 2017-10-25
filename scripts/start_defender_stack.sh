ts=$(date +%F_%H-%M-%S)
deployment="$1"
[[ -z "$deployment" ]] && echo "Missing arg: deployment" && exit 1
configd.py -L -v -d "$deployment" > /home/support/logs/configd_"$ts".log 2>&1 &
cubes_from_h5flow.py --daemon 99 -d "$deployment" -v > /home/support/logs/cubes_from_h5flow_"$ts".log  2>&1 &
detect32d.py -v -D -d "$deployment" --shard 0 > /home/support/logs/detect32d_"$ts".log 2>&1 &
incident_aggregator.py -d "$deployment" -v -D > ~/logs/incident_aggregator_"$ts".log 2>&1 &
