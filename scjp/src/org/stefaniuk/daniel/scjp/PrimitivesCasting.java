package org.stefaniuk.daniel.scjp;

public class PrimitivesCasting {
	public static void main(String[] args) {
		byte b1 = 22;
		byte b2 = (byte)1000; // must be converted
		byte b3 = 4 * 5;
		byte b4 =  (byte)(b1 * 1); // must be converted 
		int i = 1000;
		long l = 0xFFFFFFFF;
		float f = 3.5f; // must be marked 'f'
		double d = 3.4;	
		int i2 = (int)f; // must be converted
		
		int ii = (byte) 4;
		byte b = (byte) ii;
		short s = b;
		char c = (char) s;
		//java.lang.Character c2 = (Byte)(new java.lang.Byte("4"));
		char c3 = new Character('A').charValue();
		//byte bb2 = new java.lang.Byte(4);
		//java.lang.Float ft1 = Float.valueOf("").floatValue();
		//java.lang.Float ft2 = Float.valueOf("").floatValue("");
		
		int[] ai = new int[0];
		int[] kt = ai;
		//new int[2]; // wrong
		//int[] it1 = new int[0] {}; // wrong
		int[] it2 = new int[][]{{1}}[0];
		//int[][] it3 = new int[]{0}[0][0]; // wrong
		//int it4 = new int[2]{}[]; // wrong
		
		System.out.println(ai);
	}
}
