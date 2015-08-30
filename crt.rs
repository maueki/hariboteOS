#![feature(asm, lang_items, core, no_std)]
#![no_std]

extern crate core;

mod bootpack;
mod asmfunc;

use bootpack::*;

#[no_mangle]
pub fn _start() {
    hari_main();
    return;
}

#[lang = "stack_exhausted"] extern fn stack_exhausted() {}
#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "eh_unwind_resume"] extern fn eh_unwind_resume() {}
#[lang = "panic_fmt"] fn panic_fmt() -> ! { loop {} }
