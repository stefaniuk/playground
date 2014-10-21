package org.stefaniuk.daniel.scjp;

class SwitchExample {

	public static void main(String args[]) {

		//final int x; // wrong !!!
		//x = 5;
		final int x = 5;

		int i = 5;

		switch(i) {
			case 2:
				System.out.println("two");
				break;
			case 3:
				System.out.println("three");
				break;
			case x:
				System.out.println("five");
				break;

			default:
				System.out.println("don't know");

		}
	}
	
	// comment:
	// A compile time constant is a final variable with a value at compile time
	// (e.g. final int i=5;). A final variable is a variable that can only be
	// assigned once. But that doesn't have to mean that is has a value at
	// compile time (e.g. final int i; i=5); The switch statement only accepts
	// the first.
}
