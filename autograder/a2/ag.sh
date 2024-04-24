#! /bin/bash

sudo apt-get update > /dev/null
sudo apt-get install valgrind > /dev/null

wget -O ag_tests.tgz -q https://github.com/amigler/357-f23/raw/main/autograder/a2/ag_tests.tgz && tar -xf ag_tests.tgz

red=0
green=0
total=0

rm -f out_actual fs_simulator

((total++))
make
timeout 10s ./fs_simulator ag_fs1 < ag_input > out_actual
diff -y --suppress-common-lines out_actual ag_output
if [ $? -ne 0 ]; then
    echo "ERROR: fs_simulator1 (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: fs_simulator1"
    ((green++));
fi

echo $green out of $total tests passed

if [ $red -ne 0 ]; then
    exit 1
else
    exit 0
fi
