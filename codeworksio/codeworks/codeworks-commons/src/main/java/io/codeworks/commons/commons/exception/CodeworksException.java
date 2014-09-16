package io.codeworks.commons.commons.exception;

/**
 * Generic exception.
 * 
 * @author Daniel Stefaniuk
 */
public class CodeworksException extends RuntimeException {

    private static final long serialVersionUID = -2899388987163310646L;

    public CodeworksException() {

        super();
    }

    public CodeworksException(String message) {

        super(message);
    }

    public CodeworksException(Throwable cause) {

        super(cause);
    }

    public CodeworksException(String message, Throwable cause) {

        super(message, cause);
    }

}
