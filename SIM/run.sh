#!/bin/bash

set -e

########################################
# Check arguments
########################################

if [ $# -ne 1 ]; then
    echo "Usage:"
    echo "  ./SIM/run.sh <test>"
    echo
    echo "Available tests:"
    echo "  basic"
    echo "  logic"
    echo "  shift"
    echo "  compare"
    echo "  memory"
    echo "  branch"
    echo "  jump"
    echo "  immediate"
    echo "  edge"
    echo "  stress"
    exit 1
fi

TEST=$1

TESTS="basic logic shift compare memory branch jump immediate edge stress"

if [ "$TEST" = "all" ]; then

    PASS=0
    FAIL=0

    echo "========================================"
    echo "Running Complete Regression"
    echo "========================================"

    for T in $TESTS
    do
        echo
        echo "----------------------------------------"
        echo "Running $T"
        echo "----------------------------------------"

        ./SIM/run.sh $T > /tmp/riscv_regression.log 2>&1 || true

        if grep -q "ALL TESTS PASSED" /tmp/riscv_regression.log
        then
            echo "PASS : $T"
            PASS=$((PASS+1))
        else
            echo "FAIL : $T"
            FAIL=$((FAIL+1))
        fi
    done

    echo
    echo "========================================"
    echo "Regression Summary"
    echo "========================================"
    echo "Passed : $PASS"
    echo "Failed : $FAIL"
    echo "========================================"

    exit 0
fi

SRC="Programs/${TEST}_test.S"
OBJ="Programs/${TEST}_test.o"
ELF="Programs/${TEST}_test.elf"

TBFILE="TB/tests/${TEST}_test.vh"

########################################
# Check files
########################################

if [ ! -f "$SRC" ]; then
    echo "ERROR: $SRC not found."
    exit 1
fi

if [ ! -s "$SRC" ]; then
    echo "ERROR: $SRC is empty."
    exit 1
fi

if [ ! -f "$TBFILE" ]; then
    echo "ERROR: $TBFILE not found."
    exit 1
fi

########################################
echo "========================================"
echo " Running : $TEST"
echo "========================================"

########################################
# Assemble
########################################

echo "[1/6] Assembling..."

riscv64-unknown-elf-as \
"$SRC" \
-o "$OBJ"

########################################
# Link
########################################

echo "[2/6] Linking..."

riscv64-unknown-elf-ld \
-Ttext=0x0 \
"$OBJ" \
-o "$ELF"

########################################
# Generate instructions.mem
########################################

echo "[3/6] Generating instructions.mem..."

riscv64-unknown-elf-objdump -d "$ELF" |
awk '
/^[[:space:]]*[0-9a-f]+:/ {
    if(length($2)==8)
        print $2
}
' > Programs/instructions.mem

########################################
# Select test
########################################

echo "[4/6] Selecting verification..."

cp "$TBFILE" TB/tests/current_test.vh

########################################
# Compile
########################################

echo "[5/6] Compiling RTL..."

iverilog -g2005-sv \
-I TB \
RTL/*.v \
TB/riscv_core_tb.v \
-o sim.out

########################################
# Simulate
########################################

echo "[6/6] Running simulation..."
echo

vvp sim.out
