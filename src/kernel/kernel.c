#include <stdint.h>
#include <stddef.h>
#include "limine.h"

/*
 * We define a few colors for our logs
 */
#define COLOR_WHITE 0xFFFFFF
#define COLOR_GREEN 0x00FF00
#define COLOR_RED   0xFF0000
#define COLOR_BLUE  0x000044

/*
 * Official Limine Request.
 */
__attribute__((section(".limine_requests")))
struct limine_framebuffer_request fb_req = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,
    .revision = 0,
    .response = NULL
};

void put_pixel(struct limine_framebuffer* fb, int x, int y, uint32_t color) {
    uint32_t* ptr = (uint32_t*)fb->address;
    ptr[y * (fb->pitch / 4) + x] = color;
}

/*
 * Minimalist print function.
 * Draws 8x8 blocks to simulate characters.
 */
void kprint(struct limine_framebuffer* fb, const char* str, int x, int y, uint32_t color) {
    for (int i = 0; str[i] != '\0'; i++) {
        for (int dy = 0; dy < 8; dy++) {
            for (int dx = 0; dx < 8; dx++) {
                put_pixel(fb, x + (i * 8) + dx, y + dy, color);
            }
        }
    }
}

/*
 * Error Screen: Fills the screen with red and prints the error message.
 */
void panic(struct limine_framebuffer* fb, const char* msg) {
    if (fb) {
        for (uint64_t y = 0; y < fb->height; y++) {
            for (uint64_t x = 0; x < fb->width; x++) {
                put_pixel(fb, x, y, COLOR_RED);
            }
        }
        kprint(fb, "KERNEL PANIC:", 20, 20, COLOR_WHITE);
        kprint(fb, msg, 20, 30, COLOR_WHITE);
    }
    while (1) { __asm__("hlt"); }
}

void kernel_main(void) {
    /*
     * Step 1: Check if framebuffer request was answered.
     * We can't print logs until we have a framebuffer, so if this fails,
     * we can't show a red screen either.
     */
    struct limine_framebuffer_response *resp = fb_req.response;
    if (!resp || resp->framebuffer_count == 0) {
        /* Absolute failure: no way to output to screen */
        while (1) { __asm__("hlt"); }
    }

    struct limine_framebuffer *fb = resp->framebuffers[0];
    if (!fb) {
        while (1) { __asm__("hlt"); }
    }

    /*
     * Now we have a framebuffer! Let's start logging the boot process.
     */

    /* Clear screen to Navy Blue */
    for (uint64_t y = 0; y < fb->height; y++) {
        for (uint64_t x = 0; x < fb->width; x++) {
            put_pixel(fb, x, y, COLOR_BLUE);
        }
    }

    /* Log progress */
    kprint(fb, "[ OK ] Framebuffer initialized", 20, 20, COLOR_GREEN);

    /* Simulate some checks (In a real OS, this is where you'd check memory, ACPI, etc) */
    kprint(fb, "[ OK ] Limine protocol verified", 20, 30, COLOR_GREEN);
    kprint(fb, "[ OK ] x86_64 Mode confirmed", 20, 40, COLOR_GREEN);
    kprint(fb, "[ OK ] Kernel memory mapped", 20, 50, COLOR_GREEN);

    /* Final Welcome Message */
    kprint(fb, "Welcome to homeOS!", 20, 80, COLOR_WHITE);
    kprint(fb, "Kernel initialized successfully.", 20, 90, COLOR_GREEN);

    /*
     * Example of how the panic screen works:
     * If you want to test the error screen, uncomment the line below:
     * panic(fb, "Critical Error: Memory overlap detected!");
     */

    while (1) {
        __asm__("hlt");
    }
}
