#!/bin/bash

#Get the first paramether which should be de filter
filter=$1
stat_type=$2
mem_limit=$3
min_container=$4


typeset -i num

sum=0
#iterate over all containers which matches the filter
for container_id in $(docker ps --filter="label=$filter" -q);do
  if [ "$stat_type" = "CPU" ]; then
    echo "CPU selected";
    cpu_perc=$(docker stats --format "{{.CPUPerc}}" $container_id --no-stream;)
    cpu_perc=${cpu_perc%.*}
    sum=$(expr $sum + $cpu_perc)
  elif [ "$stat_type" = "MEM" ]; then
    echo "Memory selected";
    mem_perc=$(docker stats --format "{{.MemPerc}}" $container_id --no-stream;)
    mem_perc=${mem_perc%.*}
    sum=$(expr $sum + $mem_perc)
  fi
  counter=$(expr $counter + 1)
done

sum=$(expr $sum / $counter)

#Calculate the tolerance when to scale down a container
limit_with_tolerance=$(echo "$mem_limit - $mem_limit * 0.3" | bc)
limit_with_tolerance=${limit_with_tolerance%.*}

#get all containers to see the size
containers=($(docker ps --filter="label=$filter" -q))

#Check if the sum of the containers is above of the set percentage limit and if true create a container
if [ "$sum" -gt "$mem_limit" ];then
  echo "Higher than set limit";
  #Create new container since the memory sum is too high
  docker run -e POSTGRES_PASSWORD=lernplattform \
  -e POSTGRES_USER=internaluser -e POSTGRES_DB=lernplattform \
  --label $filter --memory=500m -d -P postgres:12-alpine

#if the load is lower than the limit destroy a container
elif [ "$sum" -gt "$limit_with_tolerance" ]; then
  echo "lower than set limit";
  if [ "${#containers[@]}" -gt "$min_container" ]; then
    docker stop ${containers[0]} && docker rm ${containers[0]}
  elif [ "${#containers[@]}" -lt "$min_container" ]; then
    #Create new container since the memory sum is too high
    docker run -e POSTGRES_PASSWORD=lernplattform \
    -e POSTGRES_USER=internaluser -e POSTGRES_DB=lernplattform \
    --label $filter --memory=500m -d -P postgres:12-alpine
  fi
#There are more containers than necessary
elif [ "${#containers[@]}" -gt "$min_container" ]; then
    docker stop ${containers[0]} && docker rm ${containers[0]}
# the minimum containers are not fullfilled
elif [ "${#containers[@]}" -lt "$min_container" ]; then
    #Create new container since the memory sum is too high
    docker run -e POSTGRES_PASSWORD=lernplattform \
    -e POSTGRES_USER=internaluser -e POSTGRES_DB=lernplattform \
    --label $filter --memory=500m -d -P postgres:12-alpine
fi

$SHELL
