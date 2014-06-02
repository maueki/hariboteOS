
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

enum Color{
	BLACK = 0,
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

typedef std::tuple<unsigned char, unsigned char, unsigned char> color;

void init_palette();
void set_palette(const std::array<color, Color::MAX_NUM>&);
void boxfill8(char* vram, int xsize, Color c, const Rect& rect);

void HariMain(void)
{
	init_palette();

	char * const p = reinterpret_cast<char*>(0xa0000);

	boxfill8(p, 320, RED,    {{20,  20}, {120, 120}});
	boxfill8(p, 320, YELLOW, {{70,  50}, {170, 150}});
	boxfill8(p, 320, GREEN,  {{120, 80}, {220, 180}});
	
	for(;;){
		io_hlt();
	}
}

void init_palette()
{
	static const std::array<color, Color::MAX_NUM> colors = {{color(0x00, 0x00, 0x00),
															 color(0xff, 0x00, 0x00),
															 color(0x00, 0xff, 0x00),
															 color(0xff, 0xff, 0x00),
															 color(0x00, 0x00, 0xff),
															 color(0xff, 0x00, 0xff),
															 color(0x00, 0xff, 0xff),
															 color(0xff, 0xff, 0xff),
															 color(0xc6, 0xc6, 0xc6),
															 color(0x84, 0x00, 0x00),
															 color(0x00, 0x84, 0x00),
															 color(0x84, 0x84, 0x00),
															 color(0x00, 0x00, 0x84),
															 color(0x84, 0x00, 0x84),
															 color(0x00, 0x84, 0x84),
															  color(0x84, 0x84, 0x84)}};
	set_palette(colors);
	return;
}

void set_palette(const std::array<color, MAX_NUM>& colors)
{
	const int eflags = io_load_eflags();
	io_cli();
	io_out8(0x03c8, 0);
	for(const color& c: colors){
		io_out8(0x03c9, std::get<0>(c)/4);
		io_out8(0x03c9, std::get<1>(c)/4);
		io_out8(0x03c9, std::get<2>(c)/4);
	}
	io_store_eflags(eflags);

	return;
}

void boxfill8(char* vram, int xsize, Color c, const Rect& rect)
{
	for(int y = rect.top_left.y; y <= rect.bottom_right.y; ++y){
		for(int x = rect.top_left.x; x <= rect.bottom_right.x; ++x){
			vram[y * xsize + x] = static_cast<int>(c);
		}
	}
}
