#ifndef _HARDWARE_MAILBOX_H
#define _HARDWARE_MAILBOX_H 1

#define MBOX_BUFFER_SIZE 36

enum { MBOX_REQUEST_CODE = 0x0 };

extern volatile unsigned int mailbox_buffer[MBOX_BUFFER_SIZE];

#endif // #ifndef _HARDWARE_MAILBOX_H