#! /bin/bash

wget -O ag_tests.tgz -q https://github.com/amigler/357-f23/raw/main/autograder/a2/ag_tests.tgz && tar -xf ag_tests.tgz

red=0
green=0
total=0

rm -f out_actual fs_simulator

if [ "$1" = "valgrind" ]; then

  if ! command -v valgrind &> /dev/null ; then
    echo "Installing valgrind..."
    sudo apt-get -yq update > /dev/null
    sudo apt-get -yq install valgrind > /dev/null
    echo "Done installing valgrind"
  fi
  
  make
  if [ $? -ne 0 ]; then
    echo "ERROR: make"
    exit 1
  fi

  ((total++))
  rm -f out_valgrind
  timeout 10s valgrind --leak-check=full ./fs_simulator ag_fs1 < ag_input 2>&1 | grep "ERROR SUMMARY" | cut -d' ' -f4-5 > out_valgrind
  diff -yw out_valgrind <(echo "0 errors") 
  if [ $? -ne 0 ]; then
    ((red++));
    echo "ERROR: valgrind errors found"
  else
    echo "SUCCESS: valgrind"
    ((green++));
  fi

else

  make
  if [ $? -ne 0 ]; then
    echo "ERROR: make"
    exit 1
  fi

  ((total++))
  timeout 10s ./fs_simulator ag_fs1 < ag_input > out_actual
  diff -y --suppress-common-lines out_actual ag_output
  if [ $? -ne 0 ]; then
    echo "ERROR: fs_simulator1 (actual / expected shown above)"
    ((red++));
  else
    echo "SUCCESS: fs_simulator1"
    ((green++));
  fi

fi


echo $green out of $total tests passed

if [ $red -ne 0 ]; then
    exit 1
else
    exit 0
fi
