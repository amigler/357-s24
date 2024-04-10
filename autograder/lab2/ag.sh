#! /bin/sh

echo "OK"

exit 0



rm -f task1 task2

gcc task1.c -o task1

./task1 here are -some command-line -arguments with some -dashes

#-some
#-arguments
#-dashes


./task1 no args with dashes

./task1 -all -args -with -dashes


gcc task2.c -o task2 && echo "   \t a a aaa\t \n       abc " > test2a

./task2 test2a

#17


gcc task2.c -o task2 && touch empty_file

./task2 empty_file

#0


