#! /bin/bash

red=0
green=0
total=0

rm -f wc357 uniq357 out_* test_*

((total++))
gcc word_count.c -o wc357 && echo -e "a aa\nbbbb\nc\n\naaa, 123\n" > test_wc1
./wc357 test_wc1 > out_actual && wc test_wc1 | awk '{print $1,$2,$3}' > out_expected
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: wc1"
    ((green++));
fi

rm -f out_* test_*

((total++))
./wc357 word_count.c > out_actual && wc word_count.c | awk '{print $1,$2,$3}' > out_expected
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: wc2"
    ((green++));
fi

rm -f out_* test_*

((total++))
echo -e "\n" > test_wc2
./wc357 test_wc2 > out_actual && wc test_wc2 | awk '{print $1,$2,$3}' > out_expected
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: wc3"
    ((green++));
fi

rm -f out_* test_*

gcc uniq.c -o uniq357

((total++))
echo -e "a\naa\naa\naa\nb\naa\na" > test_uniq1
./uniq357 test_uniq1 > out_actual && uniq test_uniq1 > out_expected
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: uniq1"
    ((green++));
fi

rm -f out_* test_*

((total++))
./uniq357 uniq.c > out_actual && uniq uniq.c > out_expected
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: uniq2"
    ((green++));
fi

rm -f out_* test_*

((total++))
echo -e "a\na\na\na\n\naa\naa\na\na\n" > test_uniq3
./uniq357 test_uniq3 > out_actual && uniq test_uniq3 > out_expected
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    ((red++));
else
    echo "SUCCESS: uniq3"
    ((green++));
fi

echo $green out of $total tests passed

if [ $red -ne 0 ]; then
    exit 1
else
    exit 0
fi
