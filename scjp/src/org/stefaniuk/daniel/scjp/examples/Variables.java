package org.stefaniuk.daniel.scjp.examples;

public class Variables {
	{
		b = 10; // b must be declared elsewhere
	}
	//int a = b;  // does not compile
	int a1 = b = 20; // b must be declared elsewhere
	final int a2 = getB(); 
	int getB() {
		return b;
	}
	int b = getB();
	
	//char c1 = '\\u000A'; // !!! remove single \
	//char c2 = '\\u000D'; // !!! remove single \
	
	public static void main(String[] args) {
		Variables v = new Variables();
		System.out.println(v.a1 + " " + v.a2 + " " + v.b);
	}
}
