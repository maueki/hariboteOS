
#include <tuple>
#include <array>

#ifdef __cplusplus
extern "C"
{
#endif

void io_hlt();
void io_cli();
void io_out8(int port, int data);
int io_load_eflags();
void io_store_eflags(int eflags);

#ifdef __cplusplus
}
#endif

enum class ColorType{ BLACK = 0,
        RED,
        GREEN,
	YELLOW,
	BLUE,
	MAGENTA,
	CYAN,
	WHITE,
	LIGHT_GRAY,
	DARK_RED,
	DARK_GREEN,
	DARK_YELLOW,
	DARK_BLUE,
	DARK_MAGENTA,
	DARK_CYAN,
	DARK_GRAY,
	MAX_NUM
        };

struct Point
{
    int x;
    int y;
};

struct Rect
{
    Point top_left;
    Point bottom_right;
};

typedef std::tuple<unsigned char, unsigned char, unsigned char> Color;
typedef std::array<Color, static_cast<size_t>(ColorType::MAX_NUM)> Colors;

void init_palette();
void set_palette(const Colors&);
void boxfill8(char* vram, int xsize, ColorType c, const Rect& rect);

void HariMain(void)
{
    init_palette();

    char * const vram = reinterpret_cast<char*>(0xa0000);

    int xsize = 320; 
    int ysize = 200;

    
    boxfill8(vram, xsize, ColorType::DARK_CYAN,  Rect({{0,  0},        {xsize-1, ysize-29}}));
    boxfill8(vram, xsize, ColorType::LIGHT_GRAY, Rect({{0,  ysize-28}, {xsize-1, ysize-28}}));
    boxfill8(vram, xsize, ColorType::WHITE,      Rect({{0,  ysize-27}, {xsize-1, ysize-27}}));
    boxfill8(vram, xsize, ColorType::LIGHT_GRAY, Rect({{0,  ysize-26}, {xsize-1, ysize-1}}));

    boxfill8(vram, xsize, ColorType::WHITE,      Rect({{3,  ysize-24}, {59, ysize-24}}));
    boxfill8(vram, xsize, ColorType::WHITE,      Rect({{2,  ysize-24}, {2,  ysize-4}}));
    boxfill8(vram, xsize, ColorType::DARK_GRAY,  Rect({{3,  ysize-4},  {59, ysize-4}}));
    boxfill8(vram, xsize, ColorType::DARK_GRAY,  Rect({{59, ysize-23}, {59, ysize-5}}));
    boxfill8(vram, xsize, ColorType::BLACK,      Rect({{2,  ysize-3},  {59, ysize-3}}));
    boxfill8(vram, xsize, ColorType::BLACK,      Rect({{60, ysize-24}, {60, ysize-3}}));


    boxfill8(vram, xsize, ColorType::DARK_GRAY,  Rect({{xsize-47, ysize-24}, {xsize-4,  ysize-24}}));
    boxfill8(vram, xsize, ColorType::DARK_GRAY,  Rect({{xsize-47, ysize-23}, {xsize-47, ysize-4}}));
    boxfill8(vram, xsize, ColorType::WHITE,      Rect({{xsize-47, ysize-3},  {xsize-4,  ysize-3}}));
    boxfill8(vram, xsize, ColorType::WHITE,      Rect({{xsize-3,  ysize-24}, {xsize-3,  ysize-3}}));
	
    for(;;){
        io_hlt();
    }
}

void init_palette()
{
    static const Colors colors = {{Color(0x00, 0x00, 0x00),
                                   Color(0xff, 0x00, 0x00),
                                   Color(0x00, 0xff, 0x00),
                                   Color(0xff, 0xff, 0x00),
                                   Color(0x00, 0x00, 0xff),
                                   Color(0xff, 0x00, 0xff),
                                   Color(0x00, 0xff, 0xff),
                                   Color(0xff, 0xff, 0xff),
                                   Color(0xc6, 0xc6, 0xc6),
                                   Color(0x84, 0x00, 0x00),
                                   Color(0x00, 0x84, 0x00),
                                   Color(0x84, 0x84, 0x00),
                                   Color(0x00, 0x00, 0x84),
                                   Color(0x84, 0x00, 0x84),
                                   Color(0x00, 0x84, 0x84),
                                   Color(0x84, 0x84, 0x84)}};
    set_palette(colors);
    return;
}

void set_palette(const Colors& colors)
{
    const int eflags = io_load_eflags();
    io_cli();
    io_out8(0x03c8, 0);
    for(const Color& c: colors){
        io_out8(0x03c9, std::get<0>(c)/4);
        io_out8(0x03c9, std::get<1>(c)/4);
        io_out8(0x03c9, std::get<2>(c)/4);
    }
    io_store_eflags(eflags);

    return;
}

void boxfill8(char* vram, int xsize, ColorType c, const Rect& rect)
{
    for(int y = rect.top_left.y; y <= rect.bottom_right.y; ++y){
        for(int x = rect.top_left.x; x <= rect.bottom_right.x; ++x){
            vram[y * xsize + x] = static_cast<int>(c);
        }
    }
}
