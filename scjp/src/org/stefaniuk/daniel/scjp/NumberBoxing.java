package org.stefaniuk.daniel.scjp;

import java.util.TreeSet;

public class NumberBoxing {
	public static void main(String[] args) {
		TreeSet<Number> tree = new TreeSet<Number>();
		tree.add(108);
		//tree.add(new Byte((byte)12)); // runtime exception !!!
		//tree.add(new Double(3.12)); // runtime exception !!!
		//tree.add(new Long(123)); // runtime exception !!!
		//tree.add(null); // runtime exception !!!
		System.out.println(tree);
		
		// Explanation:
		
		Number n1 = new Integer(2);
		Number n2 = new Long(2);
		if(n1.equals(n2)) { // n2 becomes an object !!! and because of this is not equal ...
			System.out.println("they are equal");
		}
		if(n1.equals(new Integer(2))) {
			System.out.println("NOW they are equal");
		}
	}
}
