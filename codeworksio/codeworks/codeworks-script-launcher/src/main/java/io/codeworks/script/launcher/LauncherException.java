package io.codeworks.script.launcher;

public class LauncherException extends RuntimeException {

    private static final long serialVersionUID = 1355982239336777816L;

    public LauncherException() {

        super();
    }

    public LauncherException(String message) {

        super(message);
    }

    public LauncherException(Throwable cause) {

        super(cause);
    }

    public LauncherException(String message, Throwable cause) {

        super(message, cause);
    }

}
