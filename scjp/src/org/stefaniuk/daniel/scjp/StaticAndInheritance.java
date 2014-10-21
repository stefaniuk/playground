package org.stefaniuk.daniel.scjp;

public class StaticAndInheritance {
	public static void main(String[] args) {
		A a = new B();
		a.m();
		a.go();
		System.out.println(a.i1);
		System.out.println(a.i2); // !!! polymorphism applies only to instance methods
		new B().mx();
	}
}

class A {
	static int i1 = 2;
	int i2 = 4;
	static void m() { System.out.println(i1); }
	static void mx() { System.out.println("mx: " + i1); }
	void go() { System.out.println(i2); }
}
class B extends A {
	static int i1 = 3;
	int i2 = 7;
	static void m() { System.out.println(i1); } // it is NOT overridden method and cannot be non static
	void go() { System.out.println(i2); }
}
