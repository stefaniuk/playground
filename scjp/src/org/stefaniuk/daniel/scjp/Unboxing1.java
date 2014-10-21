package org.stefaniuk.daniel.scjp;


public class Unboxing1 extends Smooth {
	int x = 5;
	int y = 7;
	public static void main(String[] args) {
		new Unboxing1().go();
	}
	void go() {
		if(x > y & (Boolean)(this instanceof Unboxing1)) // unboxed to bool !!!
			System.out.println("a");
		if(Long.valueOf(4) instanceof Number) {
			System.out.println("b");
		}
	}
}

class Smooth {}