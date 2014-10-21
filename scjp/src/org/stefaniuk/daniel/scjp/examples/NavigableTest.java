package org.stefaniuk.daniel.scjp.examples;

import java.util.NavigableMap;
import java.util.Set;
import java.util.TreeMap;

public class NavigableTest {
	public static void main(String[] args) {
		NavigableMap nm = new TreeMap();
		nm.put(1, "one");
		nm.put(2, "two");
		nm.put(3, "three");
		nm.put(4, "four");
		nm.put(5, "five");
		//nm.put("s", "five"); // runtime error, not mutual comparable
		NavigableMap ss = nm.subMap(2, false, 5, false);
		Set st = ss.keySet();
		for(Object ob: st) {
			System.out.print(ob.toString() + " ");
		}
	}

}
