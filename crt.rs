#![feature(asm, lang_items)]

mod bootpack;
mod asmfunc;

use bootpack::*;

#[no_mangle]
pub fn _start() {
    hari_main();
    return;
}
