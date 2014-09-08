#ifndef __drv_h__
#define __drv_h__ 

const WCHAR deviceName[] = L"\\Device\\rtkdev";
const WCHAR deviceLinkName[] = L"\\DosDevices\\rtkdev";

extern "C" NTSTATUS DriverEntry(IN PDRIVER_OBJECT, IN PUNICODE_STRING);
extern "C" NTSTATUS OnUnload(IN PDRIVER_OBJECT);
extern "C" NTSTATUS OnIrpDispatch(PDEVICE_OBJECT, PIRP);
extern "C" NTSTATUS RtkDeviceControl(
    IN PFILE_OBJECT, 
    IN BOOLEAN,
    IN PVOID, 
    IN ULONG, 
    OUT PVOID, 
    IN ULONG, 
    IN ULONG, 
    OUT PIO_STATUS_BLOCK, 
    IN PDEVICE_OBJECT 
);

#endif	// __drv_h__