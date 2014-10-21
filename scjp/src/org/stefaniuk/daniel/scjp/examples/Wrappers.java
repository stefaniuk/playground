package org.stefaniuk.daniel.scjp.examples;

public class Wrappers {
	public static void main(String[] args) {
		// byte
		System.out.println("byte");
		Byte b1 = new Byte((byte)127);
		Byte b2 = new Byte("-128");
		System.out.println(b1.longValue());
		System.out.println(Byte.valueOf("34"));
		System.out.println(String.valueOf((byte)45.6F));
		System.out.println(Byte.valueOf((byte)100) instanceof Byte);
		// int
		System.out.println("int");
		Integer i1 = new Integer(0xFFFFFFFF);
		Integer i2 = new Integer(0xFFFFFFFF+1);
		System.out.println(i1);
		System.out.println(i2);
		System.out.println(Integer.valueOf(1000) instanceof Number);
		System.out.println(i1.longValue());
		// other
		System.out.println(String.valueOf("45.6F")); /// it will still be a String !!!
		System.out.println(String.valueOf(45.6F));
	}
}
