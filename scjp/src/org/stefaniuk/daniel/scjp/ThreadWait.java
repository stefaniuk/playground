package org.stefaniuk.daniel.scjp;

public class ThreadWait {
	public static void main(String[] args) throws InterruptedException {
		Thread t1 = new Thread(new Task());
		t1.start();
		t1.wait();
		synchronized(t1) {
			try {
				Thread t2 = new Thread(new Task());
				t2.start();
				System.out.println("MAIN: waiting...");
				t1.wait();
				System.out.println("MAIN: reasumed");
			}
			catch (InterruptedException ie) {
				System.out.println("MAIN: interrupted!");
			}
			System.out.println("MAIN: end");
		}
	}
}

class Task implements Runnable {
	int n;
	public void run() {
		System.out.println("running...");
		synchronized(this) {
			final int MAX = 10000;
			for(int i=1;i<MAX;i++) {
				n += MAX/i;
			}
			notify();
		}
		System.out.println("done!");
	}
}
 