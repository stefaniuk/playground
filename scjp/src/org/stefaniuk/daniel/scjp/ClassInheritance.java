package org.stefaniuk.daniel.scjp;

public class ClassInheritance {
	static class B extends ClassInheritance {}
	public static void main(String[] args) {
		ClassInheritance p1 = new ClassInheritance();
		ClassInheritance p2 = new B();
		B p3 = new B();
		p1 = p3;
		p2 = (ClassInheritance) p3;
		p3 = (B) p2;
		System.out.println("done!");
	}
	
}
