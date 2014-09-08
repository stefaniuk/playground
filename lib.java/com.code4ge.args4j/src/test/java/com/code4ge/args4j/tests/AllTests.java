package com.code4ge.args4j.tests;

import junit.framework.Test;
import junit.framework.TestSuite;

public class AllTests {

	public static Test suite() {

		TestSuite suite = new TestSuite("All JUnit Tests");
		suite.addTest(new TestSuite(HandlerTest.class));

		return suite;
	}

	public static void main(String[] args) {

		junit.textui.TestRunner.run(suite());
	}

}
