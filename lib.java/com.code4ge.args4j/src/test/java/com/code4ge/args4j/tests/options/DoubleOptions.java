package com.code4ge.args4j.tests.options;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class DoubleOptions {

	@Argument(index = 0)
	private double argument1;

	@Argument(index = 1)
	private Double argument2;

	@Argument(index = 2)
	private double argument3;

	@Option(name = "/opt1")
	private double option1;

	@Option(name = "/opt2")
	private Double option2;

	@Option(name = "/opt3")
	private Double option3;

	public double getArgument1() {

		return argument1;
	}

	public Double getArgument2() {

		return argument2;
	}

	public double getArgument3() {

		return argument3;
	}

	public double getOption1() {

		return option1;
	}

	public Double getOption2() {

		return option2;
	}

	public Double getOption3() {

		return option3;
	}

}
