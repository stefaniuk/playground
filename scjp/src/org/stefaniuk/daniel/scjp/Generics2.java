package org.stefaniuk.daniel.scjp;

import java.util.HashMap;
import java.util.Map;

public class Generics2 {
	public static <K, V> Map<V, K> mangle(Map<K, V> in) { // revertet !!!
		Map<V, K> out = new HashMap<V, K>();
		for(Map.Entry<K, V> entry: in.entrySet()) {
			System.out.println(entry.getValue() + " " + entry.getKey());
			out.put(entry.getValue(), entry.getKey());
		}
		return out;
	}
	public <K,V,F extends Object> K go(K k) {
		//return new K(); // wrong
		return k;
	}
	public static void main(String[] args) {
		Map m1 = new HashMap();
		m1.put("a", 1);
		m1.put("b", 2);
		Map m2 = mangle(m1); // this is allowed !!!
		System.out.println(m2.get("a") + " " + m2.get(2));
	}
}
