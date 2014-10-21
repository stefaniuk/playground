package org.stefaniuk.daniel.scjp;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ThreadVolatile extends Thread {
	static final int MAX = 100;
	static volatile int n = 0;
	static List<Integer> list = Collections.synchronizedList(new ArrayList<Integer>());
	public static void main(String[] args) throws Exception {
		for(int i = 0; i < MAX; i++) {
			new ThreadVolatile().start();
			new ThreadVolatile().start();
			new ThreadVolatile().start();
		}
		for(int i = 1; i < list.size(); i++) {
			if(list.get(i)< list.get(i - 1)) {
				System.out.println("pos: " + i + ", items: " + list.get(i - 1) + ", " + list.get(i));
			}
		}
	}
	public void run() {
		n += 1;
		list.add(n);
	}
}
