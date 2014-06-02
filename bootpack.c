#ifdef __cplusplus
extern "C"
{
#endif

void io_hlt();
void write_mem8(int addr, int data);

#ifdef __cplusplus
}
#endif

void HariMain(void)
{	
    int i;
    for(i = 0xa0000; i <= 0xaffff; i++){
        write_mem8(i, 15);
    }

    for(;;){
        io_hlt();
    }
}
