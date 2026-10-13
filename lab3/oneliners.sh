# Q1. How many requests failed?
grep FAIL access.log | cut -d' ' -f4 | wc -w
# Q2. How many different pages were requested, and which?
awk '{print $5}' access.log | sort -u | awk '{pages = pages " " $1} END {print NR ":" pages}'
# Q3. How many requests did each page get?
awk -F' ' '{print $5}' access.log | sort | uniq -c
# Q4. Which user or users have the most failed requests, and how many?
awk '$4 != "OK" {print $3, $4}' access.log | sort | uniq -c | sort -rn
# Q5. How many requests did user3 make, and how many of them failed?
awk '$3 == "user3" {print $3, $4}' access.log | sort | uniq -c | sort -rn | awk '{print $0; sum += $1} END {print "Total requests:", sum}'
# Q6. Print the last 3 failed requests, showing only time and user.
grep "FAIL" access.log  | tail -3 | awk -F' ' '{print $2, $3}'
# Q7. Which login shells appear in /etc/passwd, and how many accounts use each? (field 7, separator :)
awk -F':' '{print $7}' /etc/passwd | sort | uniq -c | sort -rn
