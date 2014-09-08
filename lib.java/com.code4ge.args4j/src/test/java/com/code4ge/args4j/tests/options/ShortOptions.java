package com.code4ge.args4j.tests.options;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class ShortOptions {

	@Argument(index = 0)
	private short argument1;

	@Argument(index = 1)
	private Short argument2;

	@Argument(index = 2)
	private short argument3;

	@Option(name = "/opt1")
	private short option1;

	@Option(name = "/opt2")
	private Short option2;

	@Option(name = "/opt3")
	private Short option3;

	public short getArgument1() {

		return argument1;
	}

	public Short getArgument2() {

		return argument2;
	}

	public short getArgument3() {

		return argument3;
	}

	public short getOption1() {

		return option1;
	}

	public Short getOption2() {

		return option2;
	}

	public Short getOption3() {

		return option3;
	}

}
