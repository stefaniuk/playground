package org.stefaniuk.daniel.scjp;

class MethodStaticTop {
	static void printMe() {
		System.out.println("super context ");
	};
}

public class MethodStatic extends MethodStaticTop {
	public static void printMe() throws ArithmeticException {
		System.out.println("sub context ");
	}
	public static void main(String argv[]) {
		MethodStaticTop mst = new MethodStatic();
		mst.printMe();
	}
}
