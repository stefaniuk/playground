package org.stefaniuk.daniel.scjp;

public class Format {
	public static void main(String[] args) {
		System.out.format("Hello world %b\n", null);
		System.out.format("Hello world %b\n", false);
		System.out.format("Hello world %b\n", new Boolean(false));
		System.out.format("Hello world %b\n", true);
		System.out.format("Hello world %b\n", "false");
		System.out.format("Hello world %b\n", "true");
		System.out.format("Hello world %b\n", "ItDoesNotMatter");
		System.out.format("Hello world %b\n", 7);
	}
}
