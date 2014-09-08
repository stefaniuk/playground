package com.code4ge.args4j.tests.options;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class IntegerOptions {

	@Argument(index = 0)
	private int argument1;

	@Argument(index = 1)
	private Integer argument2;

	@Argument(index = 2)
	private int argument3;

	@Option(name = "/opt1")
	private int option1;

	@Option(name = "/opt2")
	private Integer option2;

	@Option(name = "/opt3")
	private Integer option3;

	public int getArgument1() {

		return argument1;
	}

	public Integer getArgument2() {

		return argument2;
	}

	public int getArgument3() {

		return argument3;
	}

	public int getOption1() {

		return option1;
	}

	public Integer getOption2() {

		return option2;
	}

	public Integer getOption3() {

		return option3;
	}

}
