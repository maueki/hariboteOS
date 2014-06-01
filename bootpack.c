#ifdef __cplusplus
extern "C"
{
#endif

void io_hlt();

#ifdef __cplusplus
}
#endif

void HariMain(void)
{	
    for(;;){
        io_hlt();
    }
}
