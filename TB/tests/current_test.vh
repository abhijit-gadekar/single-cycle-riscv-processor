check_x0();

check_reg(1,32'd10);
check_reg(2,32'd20);

check_reg(3,32'd30);
check_reg(4,32'd10);

check_reg(5,32'd0);
check_reg(6,32'd30);
check_reg(7,32'd30);

/* 10 << 10 = 10240 */
check_reg(8,32'd10240);

/* 20 >> 10 = 0 */
check_reg(9,32'd0);

check_reg(10,32'd1);

check_reg(11,32'd30);

check_mem(0,32'd30);
