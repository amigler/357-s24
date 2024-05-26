#! /bin/bash

wget -O a4_tests.tgz -q https://github.com/amigler/csc357-s23/blob/main/a4/a4_tests.tgz?raw=true && tar -xf a4_tests.tgz

red=0
green=0
total=0

rm -f out_actual a4download

make
if [ $? -ne 0 ]; then
  echo "ERROR: make"
  exit 1
fi


if [ "$1" = "valgrind" ]; then

    rm -f out_actual out_ag_files ag_file*
    timeout 45s ./a4download ag_input.txt 3 > out_actual
    # list downloaded files and sizes for comparison
    (/bin/ls -ls ag_file* > /dev/null && (/bin/ls -ls ag_file* | awk '{print $6,$10}' > out_ag_files)) || (echo "No downloaded files found. Your program output: " && cat out_actual)
    diff -q -a -y out_ag_files ag_expected.txt
    if [ $? -ne 0 ]; then
	echo "Functionality incomplete, valgrind check skipped"
	exit 1
    fi

    if ! command -v valgrind &> /dev/null ; then
	echo "Installing valgrind..."
	sudo apt-get -yq update > /dev/null
	sudo apt-get -yq install valgrind > /dev/null
	echo "Done installing valgrind"
    fi
  
    ((total++))
    rm -f out_valgrind
    timeout 45s valgrind --leak-check=full ./a4download ag_input.txt 3 2>&1 | grep "ERROR SUMMARY" | cut -d' ' -f4-5 | uniq > out_valgrind
    diff -a -yw out_valgrind <(echo "0 errors") 
    if [ $? -ne 0 ]; then
	((red++));
	echo "ERROR: valgrind errors found"
    else
	echo "SUCCESS: valgrind"
	((green++));
    fi

elif [ "$1" = "concurrent" ]; then

    echo -e "ag_file1 https://httpbin.org/delay/10\nag_file2 https://httpbin.org/delay/10\nag_file3 https://httpbin.org/delay/10" > ag_delays.txt

    echo -e "ag_file1\nag_file2\nag_file3" > ag_delays_expected
    
    ((total++))
    rm -f out_actual out_ag_files ag_file*
    timeout 11s ./a4download ag_delays.txt 3 > out_actual
    # list downloaded files and sizes for comparison
    (/bin/ls -ls ag_file* > /dev/null && (/bin/ls -ls ag_file* | awk '{print $10}' > out_ag_files)) || (echo "No downloaded files found. Your program output: " && cat out_actual)
    diff -a -y out_ag_files ag_delays_expected
    if [ $? -ne 0 ]; then
	echo "ERROR: a4download (actual / expected shown above)"
	((red++));
    else
	echo "SUCCESS: a4download"
	((green++));
    fi

elif [ "$1" = "style" ]; then

    echo "Review will be performed manually, based on the following:"
    echo " - Internally consisistent code formatting / variable naming conventions"
    echo " - Appropriate functional decomposition decomposition (ie. no large blocks of duplicated code)"
    echo " - Clarity of logic and execution paths (ie. no deeply-nested, difficult-to-read conditional statements or loops)"
    exit 1
    
else

    ((total++))
    rm -f out_actual
    rm -f out_actual out_ag_files ag_file*
    timeout 45s ./a4download ag_input.txt 3 > out_actual
    # list downloaded files and sizes for comparison
    (/bin/ls -ls ag_file* > /dev/null && (/bin/ls -ls ag_file* | awk '{print $6,$10}' > out_ag_files)) || (echo "No downloaded files found. Your program output: " && cat out_actual)
    diff -a -y out_ag_files ag_expected.txt
    if [ $? -ne 0 ]; then
	echo "ERROR: a4download (actual / expected shown above)"
	((red++));
    else
	echo "SUCCESS: a4download"
	((green++));
    fi

fi

echo $green out of $total tests passed

if [ $red -ne 0 ]; then
    exit 1
else
    exit 0
fi
