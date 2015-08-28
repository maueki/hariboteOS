
mod bootpack;
use bootpack::*;

#[no_mangle]
#[no_stack_check]
pub fn _start() {
    unsafe {hari_main();}
    return;
}
