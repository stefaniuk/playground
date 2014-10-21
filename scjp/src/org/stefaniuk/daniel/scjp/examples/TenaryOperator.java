package org.stefaniuk.daniel.scjp.examples;

public class TenaryOperator {
	public static void main(String[] args) {
		boolean b1=false;
		boolean b2=true;
		Object ob= (b2=false)?((b1=true)?"A":(b1=false)?"B":9800L):((b1=false)?"C":(b2==false)?"D":new java.util.Date());
		System.out.print(ob); // = vs. ==
	}
}
