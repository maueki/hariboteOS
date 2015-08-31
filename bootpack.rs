
use asmfunc::*;

pub fn hari_main() {
    for i in 0xa0000..0xaffff {
        write_mem8(i, (i & 0x0f) as u8);
    }

    loop {
        io_hlt();
    }
}
