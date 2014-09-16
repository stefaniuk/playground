package io.codeworks.file.monitor.core;

public class FileMonitorException extends RuntimeException {

    private static final long serialVersionUID = 46386580884295006L;

    public FileMonitorException() {

        super();
    }

    public FileMonitorException(String message) {

        super(message);
    }

    public FileMonitorException(Throwable cause) {

        super(cause);
    }

    public FileMonitorException(String message, Throwable cause) {

        super(message, cause);
    }

}
