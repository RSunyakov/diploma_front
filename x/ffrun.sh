#!/bin/bash

FFRUN="fvm flutter run --enable-software-rendering -d emul"

cmd=$FFRUN
echo "Execute: $cmd"
eval "$cmd"
