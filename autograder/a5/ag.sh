#! /bin/bash

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

    echo "(autograder not yet fully configured)"
    exit 1
    
    
elif [ "$1" = "delay_endpoint" ]; then

    echo "(autograder not yet fully configured)"
    exit 1

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
