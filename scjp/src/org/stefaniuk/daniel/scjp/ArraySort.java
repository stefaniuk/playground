package org.stefaniuk.daniel.scjp;

import java.util.Arrays;

public class ArraySort {
	public int a = 0;
	ArraySort(int a) {
		this.a = a;
	}
	public String toString() {
		return "["+a+"]";
	}
	public static void main(String[] args) {
		ArraySort[] a = new ArraySort[]{new ArraySort(2),new ArraySort(1),new ArraySort(6)};
		Arrays.sort(a); // why ???
		for(ArraySort s:a) System.out.print(s);
		
	}
}
