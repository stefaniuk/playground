package org.stefaniuk.daniel.scjp.examples;

public class PrimitivesArithmeticException {
	public static void main(String[] args) {

		System.out.println(0%1); // 0
		System.out.println(1%1); // 0
		System.out.println(-1%1); // 0
		System.out.println(0%-1); // 0
		System.out.println(1%-1); // 0
		System.out.println(-1%-1); // 0
		System.out.println(9%4); // 1
		System.out.println(9%-4); // 1
		System.out.println(-9%4); // -1
		System.out.println(-9%-4); // -1

		
		double d1 = 10.1;
		double d2 = 100.1;
		double d3 = 0;
		System.out.println(d1/d2);
		System.out.println(d1/d3); // NO exception !!!
		
		int i1 = 10;
		int i2 = 100;
		int i3 = 0;
		System.out.println(i1/i2);
		System.out.println(i1/i3); // exception !!!
		
	}
}
