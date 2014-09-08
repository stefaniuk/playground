package com.code4ge.jsf.args;

/**
 * Command line exception.
 * 
 * @author Daniel Stefaniuk
 */
public class CmdLineException extends Exception {

    private static final long serialVersionUID = 1L;

    private Throwable cause;

    public CmdLineException(String message) {

        super(message);
    }

    public CmdLineException(Throwable t) {

        super(t.getMessage());

        this.cause = t;
    }

    public Throwable getCause() {

        return this.cause;
    }

}
