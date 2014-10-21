package org.stefaniuk.daniel.scjp;

public class Threads3 extends Thread {
	static Threads3 t = new Threads3();
	public synchronized void run() {
	}
	public Thread getInst() {
		return t;
	}
	public static void main(String ars[]) {
		for(int i=0; i<2; i++) {
			new Threads3().getInst().start(); // why ???
		}
	}
}
