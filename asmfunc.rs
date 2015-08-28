
pub fn io_hlt() {
    unsafe {
        asm!("hlt");
    }
}
