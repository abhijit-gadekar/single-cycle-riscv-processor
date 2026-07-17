check_x0();

/* x0 must remain zero */
check_reg(0,32'd0);

check_reg(1,32'hFFFFFFFF);

check_reg(2,32'h80000000);

check_reg(3,32'd1);

check_reg(4,32'hFFFFFFFF);

check_reg(5,32'd0);
