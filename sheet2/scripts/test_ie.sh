#!/bin/bash

ghdl -a --std=08 --work=work --workdir=build src/cpu_constants_pkg.vhd && touch build/cpu_constants_pkg.stamp
ghdl -a --std=08 --work=work --workdir=build src/immediate_ext.vhd && touch build/immediate_ext.stamp
ghdl -a --std=08 --work=work --workdir=build src_tb/tb_immediate_ext.vhd && touch build/tb_immediate_ext.stamp
ghdl -e --std=08 --work=work --workdir=build -o build/tb_immediate_ext tb_immediate_ext


OUTPUT=sim_output
./build/tb_immediate_ext --vcd=wave.vcd > ${OUTPUT} 2>&1
RETCODE=$?
if [[ "$RETCODE" -ne 0 ]]; then
    echo "Failure during testbench execution"
    echo "Take a look at the file ${OUTPUT}:"
    echo "----------"
    cat ${OUTPUT}
    echo "----------"
    exit 1
fi
NUM_FAILS=$(cat ${OUTPUT} | tee /dev/tty | grep FAIL | wc -l)
rm -f ${OUTPUT}
if [[ "$NUM_FAILS" -eq 0 ]]; then
    echo "Tests PASSED \\o/"
    exit 0
else
    echo "Tests failed /o\\"
    exit 1
fi