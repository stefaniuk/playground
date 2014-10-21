package org.stefaniuk.daniel.scjp.examples;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegEx {
	public static void main(String args[]) {
		Pattern pt = Pattern.compile("Sun Certified Java Programmer");
		Matcher mt = pt.matcher("Certified");
		mt.find();
		System.out.print(mt.group()); // throws IllegalStateException !!!
	}
}
