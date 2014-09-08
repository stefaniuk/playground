package com.code4ge.webtools.utils;

/**
 * ImageMagick Exception
 * 
 * @author Daniel Stefaniuk
 */
public class ImageMagickException extends Exception {

	private static final long serialVersionUID = 1L;

	private Throwable cause;

	public ImageMagickException(String message) {

		super("ImageMagick: " + message);
	}

	public ImageMagickException(Throwable t) {

		super(t.getMessage());

		this.cause = t;
	}

	public Throwable getCause() {

		return this.cause;
	}

}
