# scaler

bash scripts which do auto-scaling on different environments<br/>


## docker-scaler
Scales docker containers based on defined filter, a type and a defined memory or cpu limit (Percentage ) and a minimum of containers
### Usage
Run sh with: ./docker-scaler.sh TYPE FILTER MEMORY_limit MIN_CONTAINER<br/>
example: ./docker-scaler.sh CPU app=db 80 1<br/>
or: sudo ./docker-scaler.sh MEM app=db 60 2<br/>

### Additonal information
It will scale up if the average sum is higher than the limit or the number of containers is lower than the defined minimum of containers<br/>
It will scale down if the limit with 30 percent tolerance is lower than the sum and the number of containers is not higher than the number of minimum containers 
