#!/bin/sh
set -e

if [ $# -lt 1 ]; then
  echo "Error: No filename supplied." >&2
  echo "Usage: $0 <filename>" >&2
  exit 1
fi

if [ ! -e "$1" ]; then
  echo "Error: File '$1' does not exist." >&2
  exit 1
fi

poke -L /dev/stdin "$@" << 'EOF'
  open (argv[0]);
  uint<8>[3] @ 8#B = ['A', 'I', 0x02UB];
EOF
