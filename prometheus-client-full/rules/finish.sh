#!/bin/bash

vals=("message" "deny" "error")

val=${vals[ $RANDOM % ${#vals[@]} ]}

cat << EOF
{
    "$val": "world"
}
EOF