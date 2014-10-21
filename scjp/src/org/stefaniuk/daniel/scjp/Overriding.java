package org.stefaniuk.daniel.scjp;

public class Overriding {
	public static void main(String[]ddd) {
		System.out.println(new OverridingB().getName());
		System.out.println(new OverridingC().getName());
		System.out.println(new OverridingD().getName());
	}
}
class OverridingA {
	String name = "A";
	String getName() {
		return name;
	}
}
class OverridingB extends OverridingA {
	String name="B"; 
}
// comment:
// variables are never overridden. Declaring a new variable in the subclass has
// no effect whatsoever on how the method getName() works.
//
// A subclass cannot override fields of the superclass, but it can hide them.
// The subclass can define fields with the same name as in the superclass. If
// this is the case, the fields in the superclass cannot be accessed in the
// subclass by their simple names; therefore, they are not inherited by the
// subclass.

class OverridingC extends OverridingA {
	String name="C";
	String getName() {
		return name;
	}
}
class OverridingD extends OverridingA {
	String name="D";
	String getName() {
		return super.name;
	}
}