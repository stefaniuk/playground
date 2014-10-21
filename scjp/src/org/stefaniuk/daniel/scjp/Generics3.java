package org.stefaniuk.daniel.scjp;

class GFood {}
class GFruit extends GFood {}
class GApple extends GFruit {}

public class Generics3<T extends GFood> {
//public class Generics3<T extends GFruit> { // ok
//public class Generics3<T extends GApple> { // fails
//public class Generics3<T super GApple> { // CANNOT use super here !!!
//public class Generics3<T> { // ok
	public static void main(String[] args) {
		Generics3<GFruit> p = new Generics3<GFruit>();
	}
}