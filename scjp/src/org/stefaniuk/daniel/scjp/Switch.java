package org.stefaniuk.daniel.scjp;

public class Switch {
	public final static int CONSTANT = 78;
	public static void main(String[] args) {
		switch(CONSTANT) {
			default:
				switch(CONSTANT+2) {
					case 78: System.out.print("B");
					case 79: System.out.print("C");
					case 80: System.out.print("D");
					default: System.out.print("E");
				}
			case 80: System.out.print("F");
		}
	}
}
