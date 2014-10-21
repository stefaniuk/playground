package org.stefaniuk.daniel.scjp;

public class EnumPrint {
	enum Turn {
		NONE,
		INT(10),
		ON("bright"),
		OFF("dark");
		Turn() {} // constructor must be provided
		Turn(int i) {} // constructor must be provided
		Turn(String s) {} // constructor must be provided
	}
	public static void main(String[] args) {
		System.out.println(Turn.NONE);
		System.out.println(Turn.OFF);
		System.out.println(Turn.INT);
		System.out.println(Turn.INT.name() + " " + Turn.INT.ordinal());
		Turn t = Turn.NONE;
		switch(t) {
			case NONE: break;
		}
	}
}
