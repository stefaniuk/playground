package org.stefaniuk.daniel.scjp;

public class MethodOverriding {
	public static void main(String[] args) {
		new MOBeta().doStuff(10);
	}
	private final void mm() {};
}

class MOAlpha {
	int doStuff(float a) { return 7; }
}
class MOBeta extends MOAlpha {
	protected int doStuff(float b) { return 4; } // ok	
	//private int doStuff(float b) { return 4; }
	//Integer doStuff(float b) { return 7; }
	//final int doStuff(float b) { return 7; } // ok
	//long doStuff(float b) { return 7; }
}
