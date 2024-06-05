#! /bin/bash

curl --version

# a5 for spring 2024
wget -O a5_tests.tgz -q https://github.com/amigler/csc357-s23/blob/main/a6/a6_tests.tgz?raw=true && tar -xf a5_tests.tgz

red=0
green=0
total=0

rm -f out_actual httpd

make
if [ $? -ne 0 ]; then
  echo "ERROR: make"
  exit 1
fi


if [ "$1" = "valgrind" ]; then
    
    echo "(autograder not yet fully configured)"
    exit 1

elif [ "$1" = "head_request" ]; then

    ./httpd 9001 &

    ((total++))
    timeout 2 curl -s -I http://localhost:9001/a5_tests.tgz > ag_HEAD_out
    diff -a -yw ag_HEAD_out <(echo "HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1086
")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: HEAD request"
    else
	echo "SUCCESS: HEAD request"
	((green++));
    fi

    ((total++))
    timeout 2 curl -s -I http://localhost:9001/not_a_real_file | head -1 > ag_HEAD_out
    diff -a -yw ag_HEAD_out <(echo "HTTP/1.1 404 Not Found")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: HEAD request for file that does not exist"
    else
	echo "SUCCESS: HEAD request for file that does not exist"
	((green++));
    fi
    
    
elif [ "$1" = "delay_endpoint" ]; then

    ./httpd 9002 &
    
    echo "url = \"http://localhost:9002/delay/3\"
url = \"http://localhost:9002/delay/3\"
url = \"http://localhost:9002/delay/3\"
url = \"http://localhost:9002/delay/3\"" > ag_delays.txt

    ((total++))
    timeout 4 curl -s --parallel --parallel-immediate --config ag_delays.txt | head -1 > ag_delay_out
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: Parallel requests for delay endpoint timed out"
    else
	((green++));
	echo "SUCCESS: Parallel requests for delay endpoint"
    fi
    
elif [ "$1" = "error_handling" ]; then

    echo "(review to be performed manually)"
    exit 1

elif [ "$1" = "style" ]; then

    echo "Review will be performed manually, based on the following:"
    echo " - Internally consistent code formatting / variable naming conventions"
    echo " - Appropriate functional decomposition decomposition (ie. no large blocks of duplicated code)"
    echo " - Clarity of logic and execution paths (ie. no deeply-nested, difficult-to-read conditional statements or loops)"
    exit 1
        
else

    # HTTP GET
    
    rm -rf ag_out
    mkdir ag_out
    
    ./httpd 9000 &
    
    # download all .c files in local directory through httpd, compare to original
    for file in *.c *.sh; do
	if [ -f "$file" ]; then
	    timeout 2 curl -s -o "ag_out/$file" "http://localhost:9000/$file" || echo "error downloading $file" > "ag_out/$file"
	fi
    done

    for file in *.c *.sh; do
	((total++))
	if [ -f "$file" ]; then
	    diff -q "ag_out/$file" "$file"
	    if [ $? -ne 0 ]; then
		echo "ERROR: GET $file"
		((red++));
	    else
		echo "SUCCESS: GET $file"
		((green++));
	    fi
	else
	    echo "ERROR: GET $file"
	    ((red++))
	fi
    done

fi

killall -QUIT httpd  > /dev/null 2>&1

killall -9 httpd  > /dev/null 2>&1


echo $green out of $total tests passed

if [ $red -ne 0 ]; then
    exit 1
else
    exit 0
fi
