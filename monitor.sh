#!/bin/bash

# Get current CPU and Memory usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*,*\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

echo "CPU Usage: $CPU_USAGE%"
echo "Memory Usage: $MEMORY_USAGE%"

# Check if CPU usage exceeds 75%
if (( $(echo "$CPU_USAGE > 75" | bc -l) )); then
    echo "CPU Usage exceeds 75%. Triggering auto-scaling..."


    gcloud beta compute instance-groups managed create instance-group-1     --project=vcc-assign-3 \
    --base-instance-name=instance-group-1   \
        --template=my-vm-template \
        --size=1 \
        --zone=us-west1-b
    gcloud beta compute instance-groups managed set-autoscaling instance-group-1     --project=vcc-assign-3  \
    --zone=us-west1-b \
        --mode=on \
        --min-num-replicas=1 \
        --max-num-replicas=5   \
        --target-cpu-utilization=0.75 \
        --cpu-utilization-predictive-method=none \
        --cool-down-period=600

    echo "New VM instance created and firewall rules applied."
fi
