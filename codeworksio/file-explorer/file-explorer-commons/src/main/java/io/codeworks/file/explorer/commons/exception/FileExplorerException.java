package io.codeworks.file.explorer.commons.exception;

public class FileExplorerException extends RuntimeException {

    private static final long serialVersionUID = 2156561224708865249L;

    public FileExplorerException() {

        super();
    }

    public FileExplorerException(String message) {

        super(message);
    }

    public FileExplorerException(Throwable cause) {

        super(cause);
    }

    public FileExplorerException(String message, Throwable cause) {

        super(message, cause);
    }

}
