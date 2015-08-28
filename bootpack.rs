use asmfunc::*;

#[no_stack_check]
pub unsafe fn hari_main() {
    loop {
        io_hlt();
    }
}
