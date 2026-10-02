#ifndef __VIDEO_DRAW_H__
#define __VIDEO_DRAW_H__ 1

struct video_buffer {};

void paint_box(struct video_buffer* vbuffer, unsigned int x1, unsigned int y1,
               unsigned int x2, unsigned int y2, unsigned int argb);

#endif // #ifndef __VIDEO_DRAW_H__