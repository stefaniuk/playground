package org.stefaniuk.daniel.scjp;

import java.util.Arrays;
import java.util.List;

public class ArraysAsList {

	public static void main(String[] args) {

		String[] array = {"inch", "foot", "yard", "rod", "meter"};
		List list = Arrays.asList(array); // list and array are linked
		
		list.set(4, "chain");
		System.out.println(Arrays.toString(array));	
		System.out.println(list.toString());

		array[2] = "meter";
		System.out.println(Arrays.toString(array));	
		System.out.println(list.toString());
	}

}
