#ifndef __ldr_h__
#define __ldr_h__ 

#define DRIVER			101
#define COMMANDER		102
#define DRIVER_NAME		"rtkdrv"
#define COMMANDER_NAME	"rtkcmd"
#define MAX_PATH_LEN	1024

void PrintHelp();
void ExtractFiles();
void ExtractFile(char*, char*);
void LoadDriver();
void UnloadDriver();
void PrintDriverStatus();
void CleanUp();

#endif	// __ldr_h__

