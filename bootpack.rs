extern {
    fn io_hlt();
}

#[no_stack_check]
pub unsafe fn hari_main() {
    loop {
        io_hlt();
    }
}