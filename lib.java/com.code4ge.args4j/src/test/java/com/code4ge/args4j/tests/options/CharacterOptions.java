package com.code4ge.args4j.tests.options;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;

public class CharacterOptions {

	@Argument(index = 0)
	private char argument1;

	@Argument(index = 1)
	private Character argument2;

	@Argument(index = 2)
	private char argument3;

	@Option(name = "/opt1")
	private char option1;

	@Option(name = "/opt2")
	private Character option2;

	@Option(name = "/opt3")
	private Character option3;

	public char getArgument1() {

		return argument1;
	}

	public Character getArgument2() {

		return argument2;
	}

	public char getArgument3() {

		return argument3;
	}

	public char getOption1() {

		return option1;
	}

	public Character getOption2() {

		return option2;
	}

	public Character getOption3() {

		return option3;
	}

}
