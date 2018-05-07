#!/bin/sh
for i in $(seq 1 100); do
	if [ ! -f $i.html ]; then
		curl -m 3 -o $i.html -H "User-Agent: ." -H "Cookie: PHPSESSID=" "https://hustoj.example.com/JudgeOnline/problem.php?id=$i"
	fi
done
