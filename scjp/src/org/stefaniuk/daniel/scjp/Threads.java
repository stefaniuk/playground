package org.stefaniuk.daniel.scjp;


public class Threads {

	public static void main(String[] args) {
		Forecaster f = new Forecaster();
		new Listener(f);
		new Listener(f);
		new Listener(f);		
	}
	static class Forecaster extends Thread {
		private int t;
		public Forecaster() { start(); }
		public synchronized int getTemperature() { return t; }
		public void run() {
			try {
				for(;;) {
					sleep(1000);
					synchronized(this) {
						t = (int) (40 * Math.random() - 10);
						notifyAll(); // !!! notifyAll - notify all the listeners moving them to the runnable state
					}
				}
			}
			catch (Exception e) {}
		}
	}
	static class Listener extends Thread {
		private final Forecaster f;
		public Listener(Forecaster f) {
			this.f = f;
			start();
		}
		public void run() {
			try {
				for(;;) {
					synchronized(f) { f.wait(); } // waits for a notification
					System.out.println("Temperature report:" + f.getTemperature() + ", Worker: " + getId());
				}
			}
			catch (Exception e) {}
		}
	}
}
