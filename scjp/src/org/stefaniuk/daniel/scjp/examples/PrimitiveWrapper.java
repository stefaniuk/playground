package org.stefaniuk.daniel.scjp.examples;

public class PrimitiveWrapper {
	public static void tMeth(int... i) {
		System.out.print("A ");
		for(int ii: i) { System.out.print(ii); }
		System.out.println();
	}
	public static void tMeth(Integer... i) {
		System.out.print("B ");
		for(Integer ii: i) { System.out.print(ii); }
		System.out.println();
	}
	public static void tMeth(int i) { System.out.println("C " + i); }
	public static void tMeth(Integer i) { System.out.println("D " + i); }
	public static void main(String args[]) {
		tMeth(new int[] { 1, 2, 3 }); // int...
		tMeth(new int[] { new Integer(4), new Integer(5), new Integer(6) }); // int...
		tMeth(new Integer[] { new Integer(4), new Integer(5), new Integer(6) }); // Integer...
		tMeth(7); // int
		tMeth(new Integer(7)); // Integer
		//tMeth(7, 7); // does not compile, why ???
		//tMeth(new Integer(7), new Integer(7)); // does not compile, why ???
	}
}
