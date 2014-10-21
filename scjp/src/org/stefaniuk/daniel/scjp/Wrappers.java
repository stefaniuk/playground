package org.stefaniuk.daniel.scjp;

public class Wrappers {
	public static void main(String args[]) {
		Integer i1 = 10;
		Integer i2 = 10;
		if(i1 == i2) System.out.println("objects are equal"); // true
		if(i1 != i2) System.out.println("objects are NOT equal"); // false		
		if(i1.equals(i2)) System.out.println("really equal"); // true

		Integer i3 = 1000;
		Integer i4 = 1000;
		if(i3 == i4) System.out.println("objects are equal"); // false
		if(i3 != i4) System.out.println("objects are NOT equal"); // true
		if(i3.equals(i4)) System.out.println("really equal"); // true

		Integer i5 = 10;
		int i6 = 10;
		// the wrapper will be unwrapped and the comparison will be primitive to primitive
		if(i5 == i6) System.out.println("they are equal"); // false
		if(i5 != i6) System.out.println("they are NOT equal"); // true
		if(i5.equals(i6)) System.out.println("really equal"); // true

		Integer i7 = 1000;
		int i8 = 1000;
		// the wrapper will be unwrapped and the comparison will be primitive to primitive
		if(i7 == i8) System.out.println("they are equal"); // false
		if(i7 != i8) System.out.println("they are NOT equal"); // true
		if(i7.equals(i8)) System.out.println("really equal"); // true

		// comment:
		// Two instances of the wrapper objects Boolean, Byte, Character from
		// \u0000 to \u007f and short and integer from -128 to 127 will always
		// be == when their primitive values are same
	}
}
