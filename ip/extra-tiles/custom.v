//module clk_buf(input A, output X);
//assign X = A;
//endmodule

// (* blackbox *)
// blacbox prevents logic loops, but OpenROAD
// doesn't find the instance later on...
//module break_comb_loop(input A, output X);
//assign X = A;
//endmodule
