package org.stefaniuk.daniel.scjp;

final public class SwitchPermissible {
	final public static void main(String[] args) {
		final int x = 5;
		byte i = 5;
		switch(i) {
			case 2:
			case 3:
			case x-20:
			case x+500-500:
			//case x+2000: // wrong
			default:
				System.out.println("end");
		}
	}
}
