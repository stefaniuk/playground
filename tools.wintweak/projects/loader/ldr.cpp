#include <stdio.h>
#include <windows.h>
#include "ldr.h"

char strCurrentDirectory[MAX_PATH_LEN+1];
char strDriverPath[MAX_PATH_LEN+1];
char strCommanderPath[MAX_PATH_LEN+1];

void main(int argc, char* argv[])
{
	if(2!=argc)
	{
		PrintHelp();
		return;
	}

	GetCurrentDirectory(MAX_PATH_LEN, strCurrentDirectory);
	_snprintf_s(strDriverPath, MAX_PATH_LEN, "%s\\%s.sys", strCurrentDirectory, DRIVER_NAME);
	_snprintf_s(strCommanderPath, MAX_PATH_LEN, "%s\\%s.exe", strCurrentDirectory, COMMANDER_NAME);

	if(strcmp("-i", argv[1])==0 || strcmp("--install",argv[1])==0)
	{
		ExtractFiles();
		LoadDriver();
		
		DeleteFile(strDriverPath);
	}
	else if(strcmp("-u", argv[1])==0 || strcmp("--uninstall",argv[1])==0)
	{
		UnloadDriver();

		DeleteFile(strCommanderPath);
	}
	else if(strcmp("-s", argv[1])==0 || strcmp("--status",argv[1])==0)
	{
		PrintDriverStatus();
	}
	else
		PrintHelp();
}

void PrintHelp()
{
	printf("Usage:\n");
	printf(" -i, --install\n");
	printf(" -u, --uninstall\n");
	printf(" -s, --status\n");
}

void ExtractFiles()
{
	//char strPath[MAX_PATH_LEN+1];

	//_snprintf_s(strPath, MAX_PATH_LEN, "%s\\%s.sys", strCurrentDirectory, DRIVER_NAME);
	ExtractFile("DRIVER", strDriverPath);
	//_snprintf_s(strPath, MAX_PATH_LEN, "%s\\%s.exe", strCurrentDirectory, COMMANDER_NAME);
	ExtractFile("COMMANDER", strCommanderPath);
}

void ExtractFile(char* strName, char* strPath)
{
	HRSRC res = FindResource(NULL, strName, "BINARY");
	unsigned char* ptr = (unsigned char *)LockResource(LoadResource(NULL, res));
	unsigned long size = SizeofResource(NULL, res);

	HANDLE file = CreateFile(
		strPath,
		FILE_ALL_ACCESS,
		0,
		NULL,
		CREATE_ALWAYS,
		0,
		NULL
	);

	while(size--)
	{
		unsigned long numWritten;
		WriteFile(file, ptr++, 1, &numWritten, NULL);
	}
	CloseHandle(file);
}

void LoadDriver()
{
    SC_HANDLE hManager;
    SC_HANDLE hService;

    if(hManager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS))
    {
		hService = CreateService(
			hManager, 
			DRIVER_NAME, 
			DRIVER_NAME, 
			SERVICE_ALL_ACCESS, 
			SERVICE_KERNEL_DRIVER, 
			SERVICE_DEMAND_START, 
			SERVICE_ERROR_NORMAL, 
			strDriverPath, 
			NULL, 
			NULL, 
			NULL, 
			NULL, 
			NULL
		);

		if(!hService)
		{
			if(ERROR_SERVICE_EXISTS == GetLastError())
			{
				if(NULL == (hService=OpenService(hManager, DRIVER_NAME, SERVICE_ALL_ACCESS)))
					printf("unable to open the service\n");
			}
			else
				printf("unable to create the service\n");
		}

		if(hService)
		{
			if(!StartService(hService, 0, NULL))
				if(ERROR_SERVICE_ALREADY_RUNNING == GetLastError())
					printf("the service is already running\n");
				else
					printf("error %i occured\n", GetLastError());

            CloseServiceHandle(hService);
        }

		CloseServiceHandle(hManager);
    }
	else
		printf("unable to open the manager\n");
}

void UnloadDriver()
{
	SC_HANDLE hManager;
    SC_HANDLE hService;
    
	if(hManager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS))
    {
		if(NULL != (hService=OpenService(hManager, DRIVER_NAME, SERVICE_ALL_ACCESS)))
		{
			SERVICE_STATUS status;
            if(!ControlService(hService, SERVICE_CONTROL_STOP, &status))
			{
				if(ERROR_SERVICE_NOT_ACTIVE == GetLastError())
					printf("the service has not been started\n");
				else
					printf("error %i occured\n", GetLastError());
			}
			
			CloseServiceHandle(hService);
			DeleteService(hService);
        }
		else
			printf("unable to open the service\n");

        CloseServiceHandle(hManager);
    }
	else
		printf("unable to open the manager\n");
}

void PrintDriverStatus()
{
    SC_HANDLE hManager;
	SC_HANDLE hService;

    if(hManager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS))
	{
		if(NULL != (hService=OpenService(hManager, DRIVER_NAME, SERVICE_ALL_ACCESS)))
		{
			SERVICE_STATUS status;
			if(QueryServiceStatus(hService, &status))
			{

				switch(status.dwCurrentState)
				{
					case SERVICE_STOPPED:
						printf("the service is stoped\n");
						break;
					case SERVICE_RUNNING:
						printf("the service is running\n");
						break;
					default:
						printf("status is unrecognized\n");
						break;
				}
			}
			else
				printf("error %i occured\n", GetLastError());

			CloseServiceHandle(hService);
		}
		else
			printf("unable to open the service\n");

		CloseServiceHandle(hManager);
	}
	else
		printf("unable to open the manager\n");
}
