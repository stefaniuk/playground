package com.code4ge.args4j.tests;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Arrays;

import junit.framework.TestCase;


import com.code4ge.args4j.Parser;
import com.code4ge.args4j.tests.options.BooleanOptions;
import com.code4ge.args4j.tests.options.ByteOptions;
import com.code4ge.args4j.tests.options.CharacterOptions;
import com.code4ge.args4j.tests.options.DoubleOptions;
import com.code4ge.args4j.tests.options.EnumOptions;
import com.code4ge.args4j.tests.options.FileOptions;
import com.code4ge.args4j.tests.options.FloatOptions;
import com.code4ge.args4j.tests.options.IntegerOptions;
import com.code4ge.args4j.tests.options.LongOptions;
import com.code4ge.args4j.tests.options.ShortOptions;
import com.code4ge.args4j.tests.options.StringArrayOptions;
import com.code4ge.args4j.tests.options.StringOptions;
import com.code4ge.args4j.tests.options.URIOptions;
import com.code4ge.args4j.tests.options.URLOptions;

public class HandlerTest extends TestCase {

	public void testBooleanHandler() throws InstantiationException, IllegalAccessException {

		BooleanOptions options = new BooleanOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] { "true", "false", "/opt1=true", "/opt2=false" });

		assertTrue(options.getArgument1());
		assertFalse(options.getArgument2());
		assertFalse(options.getArgument3());
		assertTrue(options.getOption1());
		assertFalse(options.getOption2());
		assertTrue(options.getOption3() == null);
	}

	public void testByteHandler() throws InstantiationException, IllegalAccessException {

		ByteOptions options = new ByteOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			Byte.toString(Byte.MIN_VALUE),
			Byte.toString(Byte.MAX_VALUE),
			"/opt1=" + Byte.MIN_VALUE,
			"/opt2=" + Byte.MAX_VALUE
		});

		assertTrue(options.getArgument1() == Byte.MIN_VALUE);
		assertTrue(options.getArgument2() == Byte.MAX_VALUE);
		assertTrue(options.getArgument3() == 0);
		assertTrue(options.getOption1() == Byte.MIN_VALUE);
		assertTrue(options.getOption2() == Byte.MAX_VALUE);
		assertTrue(options.getOption3() == null);
	}

	public void testCharacterHandler() throws InstantiationException, IllegalAccessException {

		CharacterOptions options = new CharacterOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			"/opt1=A",
			"/opt2=%",
			"Z",
			"*"
		});

		assertTrue(options.getArgument1() == "Z".charAt(0));
		assertTrue(options.getArgument2() == "*".charAt(0));
		assertTrue(options.getArgument3() == "\u0000".charAt(0));
		assertTrue(options.getOption1() == "A".charAt(0));
		assertTrue(options.getOption2() == "%".charAt(0));
		assertTrue(options.getOption3() == null);
	}

	public void testDoubleHandler() throws InstantiationException, IllegalAccessException {

		DoubleOptions options = new DoubleOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			Double.toString(Double.MIN_VALUE),
			Double.toString(Double.MAX_VALUE),
			"/opt1=" + Double.MIN_VALUE,
			"/opt2=" + Double.MAX_VALUE
		});

		assertTrue(options.getArgument1() == Double.MIN_VALUE);
		assertTrue(options.getArgument2() == Double.MAX_VALUE);
		assertTrue(options.getArgument3() == 0.0d);
		assertTrue(options.getOption1() == Double.MIN_VALUE);
		assertTrue(options.getOption2() == Double.MAX_VALUE);
		assertTrue(options.getOption3() == null);
	}

	public void testEnumHandler() throws InstantiationException, IllegalAccessException {

		EnumOptions options = new EnumOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			EnumOptions.E_TYPE.T1.toString(),
			EnumOptions.E_TYPE.T2.toString(),
			"/opt1=" + EnumOptions.E_TYPE.T1.toString(),
			"/opt2=" + EnumOptions.E_TYPE.T2.toString()
		});

		assertTrue(options.getArgument1().equals(EnumOptions.E_TYPE.T1));
		assertTrue(options.getArgument2().equals(EnumOptions.E_TYPE.T2));
		assertTrue(options.getArgument3() == null);
		assertTrue(options.getOption1().equals(EnumOptions.E_TYPE.T1));
		assertTrue(options.getOption2().equals(EnumOptions.E_TYPE.T2));
		assertTrue(options.getOption3() == null);
	}

	public void testFileHandler() throws InstantiationException, IllegalAccessException {

		FileOptions options = new FileOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			"/path/to/a/file",
			"\\path\\to\\a\\file",
			"/opt1=/path/to/a/file",
			"/opt2=\\path\\to\\a\\file"
		});

		assertTrue(options.getArgument1().equals(new File("/path/to/a/file")));
		assertTrue(options.getArgument2().equals(new File("\\path\\to\\a\\file")));
		assertTrue(options.getArgument3() == null);
		assertTrue(options.getOption1().equals(new File("/path/to/a/file")));
		assertTrue(options.getOption2().equals(new File("\\path\\to\\a\\file")));
		assertTrue(options.getOption3() == null);
	}

	public void testFloatHandler() throws InstantiationException, IllegalAccessException {

		FloatOptions options = new FloatOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			Float.toString(Float.MIN_VALUE),
			Float.toString(Float.MAX_VALUE),
			"/opt1=" + Float.MIN_VALUE,
			"/opt2=" + Float.MAX_VALUE
		});

		assertTrue(options.getArgument1() == Float.MIN_VALUE);
		assertTrue(options.getArgument2() == Float.MAX_VALUE);
		assertTrue(options.getArgument3() == 0.0f);
		assertTrue(options.getOption1() == Float.MIN_VALUE);
		assertTrue(options.getOption2() == Float.MAX_VALUE);
		assertTrue(options.getOption3() == null);
	}

	public void testIntegerHandler() throws InstantiationException, IllegalAccessException {

		IntegerOptions options = new IntegerOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			Integer.toString(Integer.MIN_VALUE),
			Integer.toString(Integer.MAX_VALUE),
			"/opt1=" + Integer.MIN_VALUE,
			"/opt2=" + Integer.MAX_VALUE
		});

		assertTrue(options.getArgument1() == Integer.MIN_VALUE);
		assertTrue(options.getArgument2() == Integer.MAX_VALUE);
		assertTrue(options.getArgument3() == 0);
		assertTrue(options.getOption1() == Integer.MIN_VALUE);
		assertTrue(options.getOption2() == Integer.MAX_VALUE);
		assertTrue(options.getOption3() == null);
	}

	public void testLongHandler() throws InstantiationException, IllegalAccessException {

		LongOptions options = new LongOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			Long.toString(Long.MIN_VALUE),
			Long.toString(Long.MAX_VALUE),
			"/opt1=" + Long.MIN_VALUE,
			"/opt2=" + Long.MAX_VALUE
		});

		assertTrue(options.getArgument1() == Long.MIN_VALUE);
		assertTrue(options.getArgument2() == Long.MAX_VALUE);
		assertTrue(options.getArgument3() == 0);
		assertTrue(options.getOption1() == Long.MIN_VALUE);
		assertTrue(options.getOption2() == Long.MAX_VALUE);
		assertTrue(options.getOption3() == null);
	}

	public void testShortHandler() throws InstantiationException, IllegalAccessException {

		ShortOptions options = new ShortOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			Short.toString(Short.MIN_VALUE),
			Short.toString(Short.MAX_VALUE),
			"/opt1=" + Short.MIN_VALUE,
			"/opt2=" + Short.MAX_VALUE
		});

		assertTrue(options.getArgument1() == Short.MIN_VALUE);
		assertTrue(options.getArgument2() == Short.MAX_VALUE);
		assertTrue(options.getArgument3() == 0);
		assertTrue(options.getOption1() == Short.MIN_VALUE);
		assertTrue(options.getOption2() == Short.MAX_VALUE);
		assertTrue(options.getOption3() == null);
	}

	public void testStringArrayHandler() throws InstantiationException, IllegalAccessException {

		StringArrayOptions options = new StringArrayOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			"/opt1=aa,bb,cc,dd",
			"/opt2=\"aa,bb,cc,dd\",\"ee,ff,gg,hh\"",
			"/opt3", "aa", "bb", "cc", "dd"
		});

		assertTrue("[aa, bb, cc, dd]".equals(Arrays.toString(options.getOption1())));
		assertTrue("[aa,bb,cc,dd, ee,ff,gg,hh]".equals(Arrays.toString(options.getOption2())));
		assertTrue("[aa, bb, cc, dd]".equals(Arrays.toString(options.getOption3())));
	}

	public void testStringHandler() throws InstantiationException, IllegalAccessException {

		StringOptions options = new StringOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			"/opt1=AAA",
			"/opt2=%%%",
			"ZZZ",
			"***"
		});

		assertTrue("ZZZ".equals(options.getArgument1()));
		assertTrue("***".equals(options.getArgument2()));
		assertTrue(options.getArgument3() == null);
		assertTrue("AAA".equals(options.getOption1()));
		assertTrue("%%%".equals(options.getOption2()));
		assertTrue(options.getOption3() == null);
	}

	public void testURIHandler() throws InstantiationException, IllegalAccessException, URISyntaxException {

		URIOptions options = new URIOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			"/opt1=mailto:java-net@java.sun.com",
			"/opt2=file:///~/calendar",
			"http://java.sun.com/j2se/1.3/",
			"docs/guide/collections/designfaq.html#28"
		});

		assertTrue(new URI("http://java.sun.com/j2se/1.3/").equals(options.getArgument1()));
		assertTrue(new URI("docs/guide/collections/designfaq.html#28").equals(options.getArgument2()));
		assertTrue(options.getArgument3() == null);
		assertTrue(new URI("mailto:java-net@java.sun.com").equals(options.getOption1()));
		assertTrue(new URI("file:///~/calendar").equals(options.getOption2()));
		assertTrue(options.getOption3() == null);
	}

	public void testURLHandler() throws InstantiationException, IllegalAccessException, MalformedURLException {

		URLOptions options = new URLOptions();
		Parser parser = new Parser(options);
		parser.parse(new String[] {
			"/opt1=mailto:java-net@java.sun.com",
			"/opt2=file:///~/calendar",
			"http://java.sun.com/j2se",
			"https://args4j.dev.java.net/"
		});

		assertTrue(new URL("http://java.sun.com/j2se").equals(options.getArgument1()));
		assertTrue(new URL("https://args4j.dev.java.net/").equals(options.getArgument2()));
		assertTrue(options.getArgument3() == null);
		assertTrue(new URL("mailto:java-net@java.sun.com").equals(options.getOption1()));
		assertTrue(new URL("file:///~/calendar").equals(options.getOption2()));
		assertTrue(options.getOption3() == null);
	}

}
