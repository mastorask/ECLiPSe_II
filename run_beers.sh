#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <Window> <Step>"
    exit 1
fi
WINDOW=$1
STEP=$2
swipl -q -s cerldi.prolog -g "['samples/beers/load.prolog'], er('samples/beers/beers.input', 'results', 'samples/beers/definitions.prolog', $WINDOW, $STEP), halt" -t "halt"