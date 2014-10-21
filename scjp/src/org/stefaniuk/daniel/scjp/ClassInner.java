package org.stefaniuk.daniel.scjp;

public class ClassInner {
	class A {
		int nonStaticVar;
		//static int staticVar; // not allowed
		void nonStaticMethod() {}
		//static void staticMethod() {} // not allowed
	}
	static class B {
		int nonStaticVar;
		static int staticVar;
		void nonStaticMethod() {}
		static void staticMethod() {}
	}
	class C extends B { // can inherit from a static class
		void nonStaticMethod2() {
			System.out.println(staticVar); // can access static method 
		} 
	}
}
