
pub fn io_hlt() {
    unsafe {
        asm!("hlt");
    }
}

pub fn write_mem8(addr: u32, data: u8) {
    unsafe {
        asm!("mov $0, %al
              mov $1, %edx
              mov %al, (%edx)"
             :
             : "r"(data), "r" (addr)
             : "eax", "edx"
             :"volatile");
    }
}
