currenttime=$(date +%s)

datadog_key='fake_datadog_key'
# server='http://localhost:5678'
# server="https://api.datadoghq.com/api/v1/check_run?api_key=$datadog_key"
server="http://localhost:5678/api/v1/check_run?api_key=$datadog_key"

# look for 'aes' in /proc/cpuinfo.
# datadog rules: 0: ok, 1: warning.

status=1
grep "aes2" /proc/cpuinfo > /dev/null && status=0

host_name=$(hostname)

# send in request
curl  -X POST -H "Content-type: application/json" \
-d "{ \"series\" :
         [{\"metric\":\"node.has_aes\",
          \"points\":[[$currenttime, $status]],
          \"type\":\"gauge\",
          \"host\":\"$host_name\",
          \"tags\":[\"environment:test\"]}
        ]
}" \
  $server
