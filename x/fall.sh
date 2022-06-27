#!/bin/bash

echo "Execute 3 chains:"
cmd="flutter clean && flutter pub get && flutter pub upgrade"
echo "1. Execute: $cmd"
eval "$cmd"
echo "-------------------------------------"

cmd="flutter pub run build_runner build --delete-conflicting-outputs"
echo "2. Execute: $cmd"
eval "$cmd"
echo "-------------------------------------"

cmd="flutter test test"
echo "3. Execute: $cmd"
eval "$cmd"
echo "-------------------------------------"
