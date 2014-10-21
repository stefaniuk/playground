package org.stefaniuk.daniel.scjp.examples;

public class TRead extends Thread {
	static TRead tr = new TRead(); // static variable
	public synchronized void run() {
		System.out.print("\\1//");
		System.out.print("\\2//");
	}
	public Thread getInst() {
		return tr;
	}
	public static void main(String ars[]) {
		for(int i = 0; i < 2; i++) {
			new TRead().getInst().start(); // gets the same thread every loop !!!
		}
	}
}
