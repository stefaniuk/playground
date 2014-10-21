package org.stefaniuk.daniel.scjp;

public class InheritanceConstructors {
	public InheritanceConstructors() {
		System.out.println("InheritanceConstructors ctor " + this.toString() );
	}
	class B extends InheritanceConstructors {
		B() {
			super();
			//InheritanceConstructors.this.super(); // wrong
			System.out.println("B ctor");
		}
	}
	class C extends B {
		C() {
			//super(); // wrong
			InheritanceConstructors.this.super(); // what is this !!!
			System.out.println("C ctor");
		}
	}
	public static void main(String[] args) {
		new InheritanceConstructors().new C();
	}
}
