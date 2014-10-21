package org.stefaniuk.daniel.scjp.examples;

import java.util.Arrays;

public class Array1{
	static class A {}
	static class B extends A {}
	static class C extends B {}
	static class D extends C {}
	public static void main(String args[]) {
		A[] a=new C[1];
		a[0] = new C();
		a[0] = new D();
		//a[0] = new A(); // throws ArrayStoreException
		//a[0] = new B(); // throws ArrayStoreException
		System.out.println("done");
		// comment:
		// you can do Parent[] arr = new Child[n], but assigning anything that
		// is-not a Child to Parent will throw an exception
		
		int[] it2 = new int[][]{{1}}[0];
		System.out.println(Arrays.toString(it2));
		long[] i = new long[2];
		i = i;
		System.out.println(Arrays.toString(i));
		i[1] = i[2]; // runtime error
	}
}
