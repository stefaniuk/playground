package com.code4ge.args4j.tests.options;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class StringOptions {

	@Argument(index = 0)
	private String argument1;

	@Argument(index = 1)
	private String argument2;

	@Argument(index = 2)
	private String argument3;

	@Option(name = "/opt1")
	private String option1;

	@Option(name = "/opt2")
	private String option2;

	@Option(name = "/opt3")
	private String option3;

	public String getArgument1() {

		return argument1;
	}

	public String getArgument2() {

		return argument2;
	}

	public String getArgument3() {

		return argument3;
	}

	public String getOption1() {

		return option1;
	}

	public String getOption2() {

		return option2;
	}

	public String getOption3() {

		return option3;
	}

}
