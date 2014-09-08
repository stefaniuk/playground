package com.code4ge.args4j.tests.options;

import java.net.URL;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class URLOptions {

	@Argument(index = 0)
	private URL argument1;

	@Argument(index = 1)
	private URL argument2;

	@Argument(index = 2)
	private URL argument3;

	@Option(name = "/opt1")
	private URL option1;

	@Option(name = "/opt2")
	private URL option2;

	@Option(name = "/opt3")
	private URL option3;

	public URL getArgument1() {

		return argument1;
	}

	public URL getArgument2() {

		return argument2;
	}

	public URL getArgument3() {

		return argument3;
	}

	public URL getOption1() {

		return option1;
	}

	public URL getOption2() {

		return option2;
	}

	public URL getOption3() {

		return option3;
	}

}
