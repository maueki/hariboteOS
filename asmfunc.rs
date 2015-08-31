
pub fn io_hlt() {
    unsafe {
        asm!("hlt");
    }
}

pub fn io_cli() {
    unsafe {
        asm!("cli");
    }
}

pub fn io_sti() {
    unsafe {
        asm!("sti");
    }
}

pub fn write_mem8(addr: u32, data: u8) {
    unsafe {
        asm!("mov $0, %al
              mov $1, %edx
              mov %al, (%edx)"
             :
             : "r"(data), "r" (addr)
             : "eax", "edx");
    }
}

pub fn io_out8(port: u16, data: u8) {
    unsafe {
        asm!("mov $0, %al
              mov $1, %dx
              out %al, %dx"
             :
             : "r"(data), "r"(port)
             : "eax", "edx");
    }
}

pub fn io_in8(port: u16) -> i16 {
    let mut ret: i16;
    unsafe {
        asm!("mov $1, %dx
              mov $$0, %eax
              in %al, %dx"
             : "={eax}"(ret)
             : "r"(port)
             : "eax", "edx");
    }
    ret
}

pub fn io_load_eflags() -> u32 {
    let mut ret: u32;
    unsafe {
        asm!("pushf
              pop $0"
             : "=r" (ret));
    }
    ret
}

pub fn io_store_eflags(eflags: u32) {
    unsafe {
        asm!("push $0
              popf"
             :
             : "r"(eflags));
    }
}
