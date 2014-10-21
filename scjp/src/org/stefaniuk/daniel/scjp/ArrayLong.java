package org.stefaniuk.daniel.scjp;


public class ArrayLong {
	public static void main(String[] args) {
		ArrayLong t = new ArrayLong();
		t.start();
	}
	void start() {
		long[] a1 = {1,2,3};
		long[] a2 = adjust(a1);
		System.out.println(" " + a2[0] + a2[1] + a2[2]); // here is the trick !!!
		System.out.println(a2[0] + a2[1] + a2[2] + " ");
		System.out.println(a1[0] + a1[1] + a1[2]);
	}
	long[] adjust(long[] a3) {
		a3[2] = 4;
		return a3;
	}
}
