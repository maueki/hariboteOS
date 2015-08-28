extern {
    fn io_hlt();
}

#[no_stack_check]
#[no_mangle]
pub extern fn hari_main()
{
    loop {
        unsafe {io_hlt();}
    }
}
