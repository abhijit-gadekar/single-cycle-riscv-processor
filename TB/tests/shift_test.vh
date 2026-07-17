check_x0();

check_reg(1, 32'd8);
check_reg(2, 32'd2);

check_reg(3, 32'd32);          // sll
check_reg(4, 32'd2);           // srl

check_reg(5, 32'd16);          // slli
check_reg(6, 32'd4);           // srli

check_reg(7, 32'hFFFFFFF0);    // -16
check_reg(8, 32'hFFFFFFFC);    // srai (-4)
check_reg(9, 32'hFFFFFFFC);    // sra  (-4)
