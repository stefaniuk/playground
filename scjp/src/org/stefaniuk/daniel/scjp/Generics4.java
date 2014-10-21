package org.stefaniuk.daniel.scjp;

public class Generics4 {
}

class Node<T> {}
//class AnotherNode<?> {} // wrong
//class SubNode extends Node<?> {} // wrong
class SubNode extends Node<Integer> {}
//interface INode extends Comparable<? extends Node<?>> {} // wrong
//interface INode extends Comparable<? extends Node<Integer>> {} // wrong

class OddNode extends Node<Node<?>> implements Comparable<Node<?>> { // nested wildcards are not a problem
	public int compareTo(Node<?> o) {
		return 0;
	}
}

class Stuff1<T extends B> {}
//class Stuff2<T super B> {} // wrong
// comment: What purpose would it serve? Since everything inherits from Object,
// something that must be a type that is super of B, means that it could be type
// Object. And since everything IS-A Object, it means the container can hold
// anything. What would the compiler need to type check? 
