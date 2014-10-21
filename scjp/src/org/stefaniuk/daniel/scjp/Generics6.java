package org.stefaniuk.daniel.scjp;

import java.util.Collection;

public class Generics6 {
	static void fromArrayToCollection1(Object[] a, Collection<?> c) {
	    for(Object o : a) { 
	        //c.add(o); // fail to compile
	    }
	}
	// solution:
	static <T> void fromArrayToCollection2(T[] a, Collection<T> c) {
	    for(T o : a) {
	        c.add(o);
	    }
	}
	public static void main(String[] args) {
	}
}
