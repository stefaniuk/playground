package org.stefaniuk.daniel.scjp;

import java.util.ArrayList;
import java.util.List;

class Food {}
class Fruit extends Food {}
class Apple extends Fruit {}

public class Generics {
	static void basket1(List<Fruit> list) {
		//list.add(new Integer(0));
		//list.add(new Object());
		//list.add(new Food());
		list.add(new Fruit());
		list.add(new Apple());
		list.add(null);
	}
	static void basket2(List<? extends Fruit> list) {
		//list.add(new Integer(0));
		//list.add(new Object());
		//list.add(new Food());
		//list.add(new Fruit());
		//list.add(new Apple());
		list.add(null);
	}
	static void basket3(List<? super Fruit> list) {
		//list.add(new Integer(0));
		//list.add(new Object());
		//list.add(new Food());
		list.add(new Fruit());
		list.add(new Apple());
		list.add(null);
	}
	static void basket4(List<?> list) {
		//list.add(new Integer(0));
		//list.add(new Object());
		//list.add(new Food());
		//list.add(new Fruit());
		//list.add(new Apple());
		list.add(null);
	}
	static void basket5(List list) {
		list.add(new Integer(0));
		list.add(new Object());
		list.add(new Food());
		list.add(new Fruit());
		list.add(new Apple());
		list.add(null);
	}
	public static void main(String[] args) {
		System.out.println("start");

		List<Fruit> list1a = new ArrayList<Fruit>();
		List<Apple> list1b = new ArrayList<Apple>();
		List<Food> list1c = new ArrayList<Food>();
		//List<Fruit> list1b = new ArrayList<Apple>();
		basket1(list1a); //basket1(list1b); basket1(list1c);
		basket2(list1a); basket2(list1b); //basket2(list1c);
		basket3(list1a); /*basket3(list1b);*/ basket3(list1c);
		basket4(list1a); basket4(list1b); basket4(list1c);
		basket5(list1a); basket5(list1b); basket5(list1c);

		//List<? extends Fruit> list2a = new ArrayList<Food>();
		List<? extends Fruit> list2b = new ArrayList<Fruit>();
		List<? extends Fruit> list2c = new ArrayList<Apple>();
		basket4(list2b);
		basket5(list2b);

		List<? super Fruit> list3a = new ArrayList<Food>();
		List<? super Fruit> list3b = new ArrayList<Fruit>();
		//List<? super Fruit> list3c = new ArrayList<Apple>();
		basket4(list3a);
		basket5(list3a);

		List<?> list4a = new ArrayList<Fruit>();
		//List<?> list4b = new ArrayList<?>();
		//List<?> list4c = new ArrayList<? extends Fruit>();
		//List<?> list4d = new ArrayList<? super Fruit>();
		basket4(list4a);
		basket5(list4a);

		System.out.println("end");
	}
}
