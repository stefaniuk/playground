package org.stefaniuk.daniel.scjp;

import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

public class TreeSetGenerics {

	public static void main(String[] args) {

		Set<String> set1 = new TreeSet<String>();
		set1.add("2"); // must be String
		set1.add("3");
		set1.add("1");
		for(Object o: set1) {
			System.out.println(o);
		}

		Set set2 = new TreeSet();
		set2.add((long)2); // must be the same type
		set2.add(new Long(3));
		set2.add("1");
		Iterator it = set2.iterator();
		while(it.hasNext()) {
			System.out.println(it.next());
		}

	}

}
