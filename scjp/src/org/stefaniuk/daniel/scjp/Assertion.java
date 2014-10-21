package org.stefaniuk.daniel.scjp;

public class Assertion {
	public static int m1() {
		return 1;
	}
	public static int m2() {
		return 2;
	}
	public static void main(String[] args) {
		System.out.println("start");
		int n = 1;
		assert(n==1);
		assert n < 2 : m1();
		assert n > 0 : m2();
		assert(5==5) : "print string";
		assert(5!=5) : "print string";
		System.out.println("end");
	}
}
