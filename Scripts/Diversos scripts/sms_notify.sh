#!/bin/bash
to=$1
body=2
message=${@: $body: 100}
curl --data "{\"number\":\"$to\",\"content\":\"$message\"}" --header "Content-Type: application/json" http://192.168.4.21:8201
