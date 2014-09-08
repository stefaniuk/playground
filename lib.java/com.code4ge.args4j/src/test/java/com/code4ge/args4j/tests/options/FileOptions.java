package com.code4ge.args4j.tests.options;

import java.io.File;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class FileOptions {

	@Argument(index = 0)
	private File argument1;

	@Argument(index = 1)
	private File argument2;

	@Argument(index = 2)
	private File argument3;

	@Option(name = "/opt1")
	private File option1;

	@Option(name = "/opt2")
	private File option2;

	@Option(name = "/opt3")
	private File option3;

	public File getArgument1() {

		return argument1;
	}

	public File getArgument2() {

		return argument2;
	}

	public File getArgument3() {

		return argument3;
	}

	public File getOption1() {

		return option1;
	}

	public File getOption2() {

		return option2;
	}

	public File getOption3() {

		return option3;
	}

}
