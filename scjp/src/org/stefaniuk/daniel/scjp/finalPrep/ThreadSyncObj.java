package org.stefaniuk.daniel.scjp.finalPrep;

public class ThreadSyncObj {
	static class Worker implements Runnable {
		Object lock = new Object();
		public void run() {
			lock = null;
			synchronized(lock) {
				System.out.println("sync");
			}
		}
	}
	public final static strictfp void main(String[] args) {
		new Thread(new Worker()).start();
	}
}
