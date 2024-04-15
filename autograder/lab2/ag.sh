#! /bin/sh

rm -f task1 task2 ag_out

set -e

echo -e "--task1--"

gcc task1.c -o task1

./task1 here are -some command-line -arguments with some -dashes > ag_out

echo -e "\ntask1a (expected / actual)"
diff -y <(echo -e "-some\n-arguments\n-dashes") ag_out && echo "SUCCESS: task1 a"

./task1 no args with dashes > ag_out
diff -yw <(echo "") ag_out && echo "SUCCESS: task1 a"

./task1 -all -args -with -dashes > ag_out

echo -e "\ntask1c (expected / actual)"
diff -y <(echo -e "-all\n-args\n-with\n-dashes") ag_out && echo "SUCCESS: task1 c"


echo -e "--task2--"

gcc task2.c -o task2
echo -e "   \t a a aaa\t \n       abc " > test2a
./task2 test2a > ag_out

echo -e "\ntask2a (expected / actual)"
diff -yw <(echo -e "17") ag_out && echo "SUCCESS: task2 a"

#17


touch empty_file

./task2 empty_file > ag_out

echo -e "\ntask2b (expected / actual)"
diff -yw <(echo "0") ag_out && echo "SUCCESS: task2 b"

#0

