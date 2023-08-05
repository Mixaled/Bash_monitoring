#!/bin/bash
if [[ $# -lt 1 || $# -gt 1 ]]; then
    echo "need 1 argument"
    exit 1
fi
if [[ $1 =~ ^[0-9]+$ ]]; then
    echo "error digit input"
else
    echo "$1"
fi
