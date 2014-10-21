package org.stefaniuk.daniel.scjp;

import java.util.HashMap;
import java.util.Map;

public class Generics9<E extends G9B> {
	public E getSame(E e) {
		return new G9B(); // !!!
	}
}

class G9A {}
class G9B extends G9A {}