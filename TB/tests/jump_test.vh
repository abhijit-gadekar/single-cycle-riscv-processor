check_x0();

check_reg(2,32'd22);

/* x10 should never execute */
check_reg(10,32'd0);

/* x1 contains return address after JAL */
check_reg(1,32'd4);
