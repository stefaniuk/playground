package com.code4ge.args4j.tests.options;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class EnumOptions {

	public enum E_TYPE {
		T1, T2, T3
	};

	@Argument(index = 0)
	private E_TYPE argument1;

	@Argument(index = 1)
	private E_TYPE argument2;

	@Argument(index = 2)
	private E_TYPE argument3;

	@Option(name = "/opt1")
	private E_TYPE option1;

	@Option(name = "/opt2")
	private E_TYPE option2;

	@Option(name = "/opt3")
	private E_TYPE option3;

	public E_TYPE getArgument1() {

		return argument1;
	}

	public E_TYPE getArgument2() {

		return argument2;
	}

	public E_TYPE getArgument3() {

		return argument3;
	}

	public E_TYPE getOption1() {

		return option1;
	}

	public E_TYPE getOption2() {

		return option2;
	}

	public E_TYPE getOption3() {

		return option3;
	}

}
