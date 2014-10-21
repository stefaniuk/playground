package org.stefaniuk.daniel.scjp;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SplitTest {
	public static void main(String[] args) {
		
		// 1
		String[] array = ";;aaaa;;aaa;aaaa;;".split(";");
		System.out.println(array.length);
		for (String string : array) {
			System.out.println(">"+string+"<");
		}
		
		// 2
		String a = "USB";
		a += "Code";
		System.out.println(a);
		
		// 3
		List list = new ArrayList();
		list.add("SCJP");
		list.add("SCWCD");
		list.add("SCMAD");
		list.add("SCEA");
		Collections.sort(list);
		for(Object obj: list) {
			System.out.print(obj + ",");
		}
	}
}

