#! /bin/bash

echo "Built-in tree command:"
which tree
tree -v

wget -O a3_tests.tgz -q https://github.com/amigler/csc357-s23/blob/main/a3/a3_tests.tgz?raw=true && tar -xf a3_tests.tgz && chmod 755 a3_test.sh 

red=0
green=0
total=0

rm -f out_actual tree

make
if [ $? -ne 0 ]; then
  echo "ERROR: make"
  exit 1
fi


if [ "$1" = "valgrind" ]; then

  if ! command -v valgrind &> /dev/null ; then
    echo "Installing valgrind..."
    sudo apt-get -yq update > /dev/null
    sudo apt-get -yq install valgrind > /dev/null
    echo "Done installing valgrind"
  fi
  
  ((total++))
  rm -f out_valgrind
  timeout 10s valgrind --leak-check=full ./tree ag_tree1 2>&1 | grep "ERROR SUMMARY" | cut -d' ' -f4-5 > out_valgrind
  diff -yw out_valgrind <(echo "0 errors") 
  if [ $? -ne 0 ]; then
    ((red++));
    echo "ERROR: valgrind tree errors found"
  else
    echo "SUCCESS: valgrind tree"
    ((green++));
  fi

elif [ "$1" = "arg_a" ]; then

  ((total++))
  rm -f out_actual  
  timeout 10s ./tree -a ag_tree1 > out_actual
  diff -y out_actual <(tree -a --charset=ascii ag_tree1)
  if [ $? -ne 0 ]; then
    echo "ERROR: tree -a (actual / expected shown above)"
    ((red++));
  else
    echo "SUCCESS: tree -a"
    ((green++));
  fi


elif [ "$1" = "arg_s" ]; then

  ((total++))
  rm -f out_actual
  timeout 10s ./tree -s ag_tree1 > out_actual
  diff -y out_actual <(tree -n -s --charset=ascii ag_tree1)
  if [ $? -ne 0 ]; then
    echo "ERROR: tree -s (actual / expected shown above)"
    ((red++));
  else
    echo "SUCCESS: tree -s"
    ((green++));
  fi
  
else

  ((total++))
  rm -f out_actual
  timeout 10s ./tree ag_tree1 > out_actual
  diff -y out_actual ag_expected1.txt
  if [ $? -ne 0 ]; then
    echo "ERROR: tree (actual / expected shown above)"
    ((red++));
  else
    echo "SUCCESS: tree"
    ((green++));
  fi

fi


echo $green out of $total tests passed

if [ $red -ne 0 ]; then
    exit 1
else
    exit 0
fi
