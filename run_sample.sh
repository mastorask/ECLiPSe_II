#!/bin/bash
if [ $# -ne 3 ]; then
    echo "Usage: $0 <sample_folder> <Window> <Step>"
    exit 1
fi
SAMPLE=$1
WINDOW=$2
STEP=$3
swipl -q -s cerldi.prolog -g "['samples/$SAMPLE/load.prolog'], er('samples/$SAMPLE/$SAMPLE.input', 'results', 'samples/$SAMPLE/definitions.prolog', $WINDOW, $STEP), halt" -t "halt"