#! /bin/bash

rm -f wc357 uniq357 out_* test_*

gcc word_count.c -o wc357 && echo "a aa\nbbbb\nc\n\naaa, 123\n" > test_wc1
./wc357 test_wc1 > out_actual && wc test_wc1 | awk '{print $1,$2,$3}' > out_expected && diff out_actual out_expected

./wc357 word_count.c > out_actual && wc word_count.c | awk '{print $1,$2,$3}' > out_expected && diff out_actual out_expected

echo "\n" > test_wc2
./wc357 test_wc2 > out_actual && wc test_wc2 | awk '{print $1,$2,$3}' > out_expected && diff out_actual out_expected


gcc uniq.c -o uniq357

echo -e "a\naa\naa\naa\nb\naa\na" > test_uniq1
./uniq357 test_uniq1 > out_actual && uniq test_uniq1 > out_expected && diff out_actual out_expected


./uniq357 uniq.c > out_actual && uniq uniq.c > out_expected && diff out_actual out_expected


echo -e "a\na\na\na\n\naa\naa\na\na\n" > test_uniq3
./uniq357 test_uniq3 > out_actual && uniq test_uniq3 > out_expected && diff out_actual out_expected

