#! /bin/bash

red=0
green=0
total=0

rm -f wc357 uniq357 out_* test_*

((total++))
gcc word_count.c -o wc357 && echo -e "a aa\nbbbb\nc\n\naaa, 123\n" > test_wc1
wc test_wc1 | awk '{print $1,$2,$3}' > out_expected
timeout 10s ./wc357 test_wc1 > out_actual && diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: wc1 (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: wc1"
    ((green++));
fi

rm -f out_* test_*

((total++))
gcc word_count.c -o wc357 && echo -e "a aa\nbbbb\nc\n\naaa, 123\n" > test_wc1
wc < test_wc1 | awk '{print $1,$2,$3}' > out_expected
timeout 10s ./wc357 < test_wc1 > out_actual && diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: wc1.stdin (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: wc1.stdin"
    ((green++));
fi

rm -f out_* test_*

((total++))
wc word_count.c | awk '{print $1,$2,$3}' > out_expected
timeout 10s ./wc357 word_count.c > out_actual && diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: wc2 (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: wc2"
    ((green++));
fi

rm -f out_* test_*

((total++))
echo -e "\n" > test_wc2
wc test_wc2 | awk '{print $1,$2,$3}' > out_expected
timeout 10s ./wc357 test_wc2 > out_actual && diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: wc3 (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: wc3"
    ((green++));
fi


gcc uniq.c -o uniq357

rm -f out_* test_*

((total++))
echo -e "a\naa\naa\naa\nb\naa\na" > test_uniq1
uniq test_uniq1 > out_expected
timeout 10s ./uniq357 test_uniq1 > out_actual
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: uniq1 (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: uniq1"
    ((green++));
fi

rm -f out_* test_*

((total++))
echo -e "a\naa\naa\naa\nb\naa\na" > test_uniq1
uniq < test_uniq1 > out_expected
timeout 10s ./uniq357 < test_uniq1 > out_actual
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: uniq1.stdin (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: uniq1.stdin"
    ((green++));
fi


rm -f out_* test_*

((total++))
uniq uniq.c > out_expected
timeout 10s ./uniq357 uniq.c > out_actual
diff -y --suppress-common-lines -Z out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: uniq2 (actual / expected shown above)"
    ((red++));
else
    echo "SUCCESS: uniq2"
    ((green++));
fi

rm -f out_* test_*

((total++))
echo -e "a\na\na\na\n\naa\naa\na\na\n" > test_uniq3
uniq test_uniq3 > out_expected
timeout 10s ./uniq357 test_uniq3 > out_actual
diff -y --suppress-common-lines out_actual out_expected
if [ $? -ne 0 ]; then
    echo "ERROR: uniq3 (actual / expected shown above)"
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
