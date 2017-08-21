# About
Domoticz based on Alpine edge Linux.

# Volumes
```
/config
/src/domoticz/scripts
 ```
# Ports
```
8080: Web interface port
 ```
 
# Usage
```
docker run -d --name="domoticz" \
    -v /path/to/config:/config \
    -v /path/to/scripts:/src/domoticz/scripts \
    -p 8080:8080 \
    --device /dev/ttyUSB0 \
    flo313/domoticz-alpine
```
