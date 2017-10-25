deployment=$1
if [[ "$deployment" == "" ]]; then
    echo "MISSING ARG! USAGE: ./start_configd.sh <deployment>"
    exit 1
fi
configd.py -L -v -d "$deployment" > /home/support/logs/configd.log 2>&1 &
