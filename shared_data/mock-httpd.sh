#!/bin/bash

# drawn from https://stackoverflow.com/questions/16640054/minimal-web-server-using-netcat
# This is a mock server: every request gets a 200 response, and
# the request is fully printed to the terminal.

while true; 
  do
    echo -e 'HTTP/1.1 200 OK\r\n' | nc -l 5678;
    echo # 
done