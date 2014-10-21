package org.stefaniuk.daniel.scjp;

public class Generics7 {
	static <T> void show() {
		System.out.println("show()");
	}
	static <T> void getResult(T obj) {
		System.out.println("getResult()");
	}
	public static void main(String[] args) {
		Generics7.show();
		Generics7.getResult("Hi");
	}
}
