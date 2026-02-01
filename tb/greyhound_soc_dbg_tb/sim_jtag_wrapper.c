// SPDX-FileCopyrightText: © 2025 Stefan Huwar <stefan.huwar@gmail.com>
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Modified by Stefan Huwar <stefan.huwar@gmail.com>

#include "../../ip/riscv-dbg/tb/remote_bitbang/sim_jtag.c"
#include <vpi_user.h>

// Icarus verilog only supports VPI no DPI-C
static int jtag_tick_wrapper(char* user_data) {
    vpiHandle systfref, args_iter, argh[7];
    s_vpi_value argval[7];
    int port, ret_val;
    unsigned char jtag_TCK, jtag_TMS, jtag_TDI, jtag_TRSTn, jtag_TDO;

    (void)user_data;

    // Obtain a handle to the argument list
    systfref = vpi_handle(vpiSysTfCall, NULL);
    args_iter = vpi_iterate(vpiArgument, systfref);
    
    // Grab the value of the first argument
    for (int i = 0; i < 7; i++) {
        argh[i] = vpi_scan(args_iter);
        argval[i].format = vpiIntVal;
        vpi_get_value(argh[i], &argval[i]);
    }

    port       = argval[1].value.integer;
    jtag_TCK   = argval[2].value.integer;
    jtag_TMS   = argval[3].value.integer;
    jtag_TDI   = argval[4].value.integer;
    jtag_TRSTn = argval[5].value.integer;
    jtag_TDO   = argval[6].value.integer;
    
    ret_val = jtag_tick(port, &jtag_TCK, &jtag_TMS, &jtag_TDI, &jtag_TRSTn, jtag_TDO);

    argval[0].value.integer = ret_val;
    argval[2].value.integer = jtag_TCK;
    argval[3].value.integer = jtag_TMS;
    argval[4].value.integer = jtag_TDI;
    argval[5].value.integer = jtag_TRSTn;
    vpi_put_value(argh[0], &argval[0], NULL, vpiNoDelay);

    for (int i = 2; i < 6; i++) {
        vpi_put_value(argh[i], &argval[i], NULL, vpiNoDelay);
    }

    // Cleanup and return
    vpi_free_object(args_iter);
    return 0;
}

void jtag_tick_register(void)
{
    s_vpi_systf_data tf_data;

    tf_data.type      = vpiSysTask;
    tf_data.tfname    = "$jtag_tick";
    tf_data.calltf    = jtag_tick_wrapper;
    tf_data.compiletf = 0;
    tf_data.sizetf    = 0;
    tf_data.user_data = 0;
    vpi_register_systf(&tf_data);
}

void (*vlog_startup_routines[])(void) = {
    jtag_tick_register,
    0
};
