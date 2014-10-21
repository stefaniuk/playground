package org.stefaniuk.daniel.scjp;

import java.util.ArrayList;
import java.util.List;

public class Generics5 {
	public static abstract class Animal {
		public abstract void talk();
	}
	public static class Dog extends Animal {
		public void talk() {
			System.out.println("Woof");
		}
	}
	public static class Cat extends Animal {
		public void talk() {
			System.out.println("Meow");
		}
	}
	public static void makeNoise(List<? extends Animal> list) {
		for(Animal animal: list) {
			animal.talk();
		}
	}
	public static void addCritters(List<? super Animal> list) {
		// can add anything equal or lower than Animal
		list.add(new Dog());
		list.add(new Cat());
	}
	public static void main(String... args) {
		List<Dog> dogs = new ArrayList<Dog>();
		dogs.add(new Dog());
		dogs.add(new Dog());
		List<Cat> cats = new ArrayList<Cat>();
		cats.add(new Cat());
		makeNoise(dogs);
		makeNoise(cats);

		List<Object> stuff = new ArrayList<Object>();
		addCritters(stuff); // can pass anything equal or higher than Animal 
		//makeNoise((List<Animal>)stuff); // wrong
		for(Object obj: stuff) {
			((Animal)obj).talk();
		}
	}
}
