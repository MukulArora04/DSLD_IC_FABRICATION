#!/bin/bash
set -e
cd "$(dirname "$0")"
iverilog -g2005 -o tb_tcam.vvp \
    ../rtl/tcam_top.v ../rtl/tcam_ctrl.v ../rtl/tcam_array.v \
    ../rtl/priority_encoder.v tb_tcam.v
vvp tb_tcam.vvp
