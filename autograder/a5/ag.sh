#! /bin/bash

curl --version | head -1

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

    if ! command -v valgrind &> /dev/null ; then
	echo "Installing valgrind..."
	sudo apt-get -yq update > /dev/null
	sudo apt-get -yq install valgrind > /dev/null
	echo "Done installing valgrind"
    fi

    
    ((total++))
    rm -f out_valgrind
    timeout 5s valgrind --leak-check=full ./httpd 9004 2>&1 | grep "ERROR SUMMARY" | cut -d' ' -f4-5 | uniq > out_valgrind &

    timeout 1 curl -s -I http://localhost:9004/a5_tests.tgz > ag_HEAD_out & 
    timeout 1 curl -s http://localhost:9004/a5_tests.tgz > ag_GET_out &
    timeout 1 curl -s http://localhost:9004/not_a_valid_file > ag_GET_out &
    timeout 1 curl -s -X POST -d "POST data here" http://localhost:9004/not_a_valid_file > ag_POST_out &

    sleep 6

    killall -QUIT httpd  > /dev/null 2>&1
    
    diff -a -yw out_valgrind <(echo "0 errors") 
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: valgrind errors found"
    else
	echo "SUCCESS: valgrind"
	((green++));
    fi
    

elif [ "$1" = "head_request" ]; then

    ./httpd 9001 &

    ((total++))
    timeout 2 curl -s -I http://localhost:9001/a5_tests.tgz | tr -d '\r' > ag_HEAD_out
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
    timeout 2 curl -s -I http://localhost:9001/not_a_real_file | tr -d '\r' | head -1 > ag_HEAD_out
    diff -a -yw ag_HEAD_out <(echo "HTTP/1.1 404 Not Found")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: HEAD request for file that does not exist should yield 404 error"
    else
	echo "SUCCESS: HEAD request for file that does not exist yields 404 error"
	((green++));
    fi
    
    
elif [ "$1" = "delay_endpoint" ]; then

    port=9004
    ./httpd $port &

    rm -f ag_delay_out*
    timeout 3 curl -s -v http://localhost:$port/delay/2 2>&1 | grep "^<" | tr -d '\r' | head -1 | cut -c 3- > ag_delay_req1 &
    timeout 3 curl -s -v http://localhost:$port/delay/2 2>&1 | grep "^<" | tr -d '\r' | head -1 | cut -c 3- > ag_delay_req2 &
    timeout 3 curl -s -v http://localhost:$port/delay/2 2>&1 | grep "^<" | tr -d '\r' | head -1 | cut -c 3- > ag_delay_req3 &
    timeout 3 curl -s -v http://localhost:$port/delay/2 2>&1 | grep "^<" | tr -d '\r' | head -1 | cut -c 3- > ag_delay_req4 &

    sleep 4

    ((total++))
    diff -a -yw <(awk '{print FILENAME" \"" $0"\""; nextfile}' ag_delay_req*) <(echo "ag_delay_req1 \"HTTP/1.1 200 OK\"
ag_delay_req2 \"HTTP/1.1 200 OK\"
ag_delay_req3 \"HTTP/1.1 200 OK\"
ag_delay_req4 \"HTTP/1.1 200 OK\"")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: Parallel requests for delay endpoint (4 parallel requests, actual / expected output above)"
    else
	((green++));
	echo "SUCCESS: Parallel requests for delay endpoint"
    fi
    
elif [ "$1" = "error_handling" ]; then

    ./httpd 9006 &

    ((total++))
    echo ""
    echo "Test Case #$total: GET /not_a_real_file HTTP/1.1"
    timeout 2 curl -s -v http://localhost:9006/not_a_real_file 2>&1 | grep "^<" | tr -d '\r' | head -1 | cut -c 3- > ag_GET_out
    diff -a -yw ag_GET_out <(echo "HTTP/1.1 404 Not Found")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: GET request for file that does not exist"
    else
	echo "SUCCESS: GET request for file that does not exist"
	((green++));
    fi

    rm -rf ag_dir
    mkdir ag_dir
    touch ag_test.txt
    
    ((total++))
    echo ""
    echo "Test Case #$total: GET /ag_dir/../ag_test.txt HTTP/1.1"
    timeout 2 curl -s -v http://localhost:9006/ag_dir/../ag_test.txt 2>&1 | grep "^<" | tr -d '\r' | head -1 | cut -c 3- > ag_GET_out
    diff -a -yw ag_GET_out <(echo "HTTP/1.1 404 Not Found")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: GET request with directory traversal should return 404"
    else
	echo "SUCCESS: GET request with directory traversal should return 404"
	((green++));
    fi
    
    ((total++))
    echo ""
    echo "Test Case #$total: DELETE /ag_test.txt HTTP/1.1"
    timeout 2 curl -s -v -X DELETE http://localhost:9006/ag_test.txt 2>&1 | grep "^<" | tr -d '\r' | head -1 | cut -c 3- > ag_DELETE_out
    diff -a -yw ag_DELETE_out <(echo "HTTP/1.1 501 Not Implemented")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: Invalid request type (DELETE)"
    else
	echo "SUCCESS: Invalid request type (DELETE)"
	((green++));
    fi

    ((total++))
    echo ""
    echo "Test Case #$total: Invalid HTTP request (string: GET *)"
    timeout 2 printf "GET *" | nc localhost 9006 | tr -d '\r' | head -1 > ag_INVALID_out 
    diff -a -yw ag_INVALID_out <(echo "HTTP/1.1 400 Bad Request")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: Invalid HTTP request should return 400"
    else
	echo "SUCCESS: Invalid HTTP request should return 400"
	((green++));
    fi

    ((total++))
    echo ""
    echo "Test Case #$total: Invalid HTTP request (string: execlp(\"rm -rf *\"))"
    timeout 2 printf "execlp(\"rm -rf *\")" | nc localhost 9006 | tr -d '\r' | head -1 > ag_INVALID2_out
    diff -a -yw ag_INVALID2_out <(echo "HTTP/1.1 400 Bad Request")
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: Invalid HTTP request should return 400"
    else
	echo "SUCCESS: Invalid HTTP request should return 400"
	((green++));
    fi

    

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
