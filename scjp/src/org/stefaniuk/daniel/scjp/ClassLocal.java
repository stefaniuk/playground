package org.stefaniuk.daniel.scjp;

public class ClassLocal {
	public static void main(String[] args) {
		new ClassLocal().start();
	}
	void start() {
		//int m = 5; // wrong, as LocalClass will not be able to access it
		final int m;
		m = 5;
		abstract class LocalClass {
			void go() {
				int n = m;
				System.out.println(n);
			}
		}
		final class LocalClass2 extends LocalClass {
		}
		new LocalClass2().go();
	}	
}

abstract strictfp class TTT {
	final synchronized void main() {};
}