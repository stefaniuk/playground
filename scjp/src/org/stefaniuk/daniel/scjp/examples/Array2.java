package org.stefaniuk.daniel.scjp.examples;

import java.util.Arrays;

public class Array2 /*implements Comparable<Array2>*/ {
	public int a = 0;
	Array2(int a) {
		this.a = a;
	}
	public String toString() {
		return "[" + a + "]";
	}
	/*public int compareTo(Array2 o) {
		return this.a-o.a;
	}*/
	public static void main(String args[]) {
		Array2[] a = new Array2[] { new Array2(2), new Array2(1), new Array2(6) };
		Arrays.sort(a); // comparable must be implemented
		for(Array2 s: a)
			System.out.print(s);
	}
}
