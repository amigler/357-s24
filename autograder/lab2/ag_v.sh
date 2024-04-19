#! /bin/sh

rm -f task1 task2 ag_out

sudo apt-get update
sudo apt-get install valgrind

red=0
green=0
total=0

#set -e

echo -e "--task1--"

gcc task1.c -o task1

((total++))
./task1 here are -some command-line -arguments with some -dashes > ag_out
echo -e "\ntask1a (expected / actual)"
diff -y <(echo -e "-some\n-arguments\n-dashes") ag_out
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: task1a"
    ((green++));
fi

((total++))
./task1 no args with dashes > ag_out
echo -e "\ntask1b (no output exected)"
touch empty_file
diff -yw empty_file ag_out 
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: task1 b"
    ((green++));
fi

((total++))
./task1 -all -args -with -dashes > ag_out
echo -e "\ntask1c (expected / actual)"
diff -y <(echo -e "-all\n-args\n-with\n-dashes") ag_out 
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: task1 c"
    ((green++));
fi

echo -e "\n--task2--"

gcc task2.c -o task2

((total++))
echo -e "   \t a a aaa\t \n       abc " > test2a #17
./task2 test2a > ag_out
echo -e "\ntask2a (expected / actual)"
diff -yw <(echo -e "17") ag_out 
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: task2 a"
    ((green++));
fi

((total++))
echo -e " \t  \t" > test2b  #5
./task2 test2b > ag_out
echo -e "\ntask2b (expected / actual)"
diff -yw <(echo -e "5") ag_out 
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: task2 b"
    ((green++));
fi

((total++))
touch empty_file
./task2 empty_file > ag_out
echo -e "\ntask2c (expected / actual)"
diff -yw <(echo "0") ag_out 
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: task2 c"
    ((green++));
fi

valgrind ./task2 empty_file > ag_out
cat ag_out

echo $green out of $total tests passed

if [ $red -ne 0 ]; then
    echo "Some tests did not pass"
    exit 1
else
    exit 0
fi
