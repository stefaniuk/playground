package org.stefaniuk.daniel.scjp;

import java.util.NavigableMap;
import java.util.Set;
import java.util.TreeMap;

public class TreeMapTest {

	public static void main(String... args) {

		NavigableMap nm = new TreeMap();
		nm.put(1, "on");
		nm.put(2, "tw");
		nm.put(3, "th");
		nm.put(4, "fo");
		nm.put(5, "fi");
		NavigableMap ss = nm.subMap(2, false, 5, false);
		Set st = ss.keySet();
		for(Object ob: st) {
			System.out.println(ob.toString() + " " + new StringBuffer().append(true));
		}
	}
}

