package org.stefaniuk.daniel.scjp;

public class ThreadJoin {
	public static void main(String[] args) throws InterruptedException {
		TaskA a = new TaskA();
		Thread t1 = new Thread(a);
		TaskB b = new TaskB(t1);
		Thread t2 = new Thread(b);
		t1.start();
		t2.start();
	}
}

class TaskA implements Runnable {
	public void run() {
		System.out.println("running A");
		for(int x=0;x<100;x++) {
			try {
				Thread.sleep(5);
			}
			catch (Exception e) {}
			System.out.print("A");
		}
		System.out.println("\nA is done");
	}
}
class TaskB implements Runnable {
	Thread t;
	TaskB(Thread t) { this.t = t; }
	public void run() {
		System.out.println("running B");
		try {
			t.join(); // join this thread on the end of 't'
		}
		catch (Exception e) {}
		for(int x=0;x<100;x++) {
			try {
				Thread.sleep(5);
			}
			catch (Exception e) {}
			System.out.print("B");
		}
		System.out.println("\nB is done");
	}
}

 