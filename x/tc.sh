#!/bin/bash

#---------------------------------------------------------------------------------------------------
## 1.
echo "Execute 3 chains:"
cmd="flutter test --coverage"
echo "1. Execute: $cmd"
eval "$cmd"
echo "-------------------------------------"

#---------------------------------------------------------------------------------------------------
file=test/coverage_helper_test.dart

cmd="echo \"// for coverage\" > $file "
echo "2. Execute: $cmd"
eval "$cmd"
echo "-------------------------------------"

find lib \
'!' -path '*generated*' \
'!' -name '*.g.dart' \
'!' -name '*.part.dart' \
'!' -name '*.freezed.dart' \
-name '*.dart' | cut -c4- | awk -v package=$1 \
'{printf "import '\''package:%s%s'\'';\n", package, $1}' >> $file
echo "void main(){}" >> $file

# возможно, понадобится для чистки, но не тут
##---------------------------------------------------------------------------------------------------
#lcov --remove coverage/lcov.info 'lib/*/*.freezed.dart' \
#'lib/*/*.g.dart''lib/generated/*.dart' \
#'lib/generated/*/*.dart'-o coverage/lcov.info

#---------------------------------------------------------------------------------------------------
cmd="genhtml coverage/lcov.info -o coverage/html"
echo "3. Execute: $cmd"
eval "$cmd"
echo "-------------------------------------"

