package org.stefaniuk.daniel.scjp;

public class OverridingMethod {
	public static void main(String[] args) {
		new Beta().doStuff(10);
	}
}

class Alpha {
	int doStuff(float a) { return 7; }
}
class Beta extends Alpha {
	protected int doStuff(float b) { return 4; } // ok	
	//private int doStuff(float b) { return 4; }
	//Integer doStuff(float b) { return 7; }
	//final int doStuff(float b) { return 7; } // ok
	//long doStuff(float b) { return 7; }
}

class OVTest1 {
	private int amethod(float i) {return 0;}
}
class OVTest2 extends OVTest1{
	private int amethod(float i) {return 0;}
}
