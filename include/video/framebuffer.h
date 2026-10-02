#ifndef __VIDEO_FRAMEBUFFER_H__
#define __VIDEO_FRAMEBUFFER_H__ 1

typedef unsigned int* fb_ptr_t;

struct video_buffer {
    fb_ptr_t address;
    unsigned int width;
    unsigned int height;
    unsigned int pitch;
};

struct video_buffer* framebuffer_init(unsigned int width, unsigned int height);

#endif // #ifndef __VIDEO_FRAMEBUFFER_H__