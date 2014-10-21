package org.stefaniuk.daniel.scjp;

public class Threads2 {
	public static void main(String args[]) throws Exception {
		Test test = new Test();
		test.start();
		System.out.print("Hello ");
		test.join();
		System.out.println("Yes");
	}
}
class Test extends Thread {
	public void run() {
		try {
			Thread.sleep(2000);
		}
		catch(InterruptedException e) {
		}
		for(int counter = 0; counter < 5; counter++) {
			System.out.print(counter + " ");
		}
	}
}

//"Hello 0 1 2 3 4 Yes"
//"0 Hello 1 2 3 4 Yes"
//"0 1 Hello 2 3 4 Yes"
//"0 1 2 Hello 3 4 Yes"
//"0 1 2 3 Hello 4 Yes"
//"0 1 2 3 4 Hello Yes" 

// comment: 
// the sleep(2000) makes the first answer ("Hello 0 1 2 3 4 Yes") more
// probably than others
