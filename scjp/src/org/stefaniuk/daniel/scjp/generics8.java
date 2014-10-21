package org.stefaniuk.daniel.scjp;

public class generics8 {

}

abstract class AA<K extends Number> {
	public abstract <K> K use1(Object k);
	//public abstract K<K> use2(Object k); // wrong
	//public abstract <K> AA<? extends Number> use3(AA<? super K> k); // wrong
	public abstract <K> AA<? super Number> use4(AA<? extends K> k);
	//public abstract <K> AA<K> use2(AA<K>k); // wrong
	//public abstract <K> AA<? extends Number> use3(AA<? super K> k); // wrong
	public abstract <K> AA<? super Number> use4n(AA<? extends K> k);
	//public abstract <K> AA<K> use5(AA<K> k); // wrong
	public abstract <V extends K> AA<V> use6(AA<V> k);
	//public abstract <V super K> AA<V> use7(AA<V> k); // wrong
}