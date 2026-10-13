#!/bin/bash
# usage: ./report.sh access.log 
log=$1
if [ ! -f "$log" ]; then
	echo "no such file: $log" >&2 
	exit 1
fi
total=$(wc -l < "$log") 
fails=$(grep -c FAIL "$log")
echo "$total requests, $fails failed"
awk '$4 == "FAIL" { count[$3]++ } 
END {
    for (i = 0; i <= 6; i++) {
        u = "user" i
        print u ":", (count[u] ? count[u] : 0), "failures"
    }
}' "$log"


