#!/bin/bash

cmd="flutter clean && flutter pub get && flutter pub upgrade"
echo "Execute: $cmd"
eval "$cmd"
