package org.stefaniuk.args4j.test.parameter;

import org.stefaniuk.args4j.annotation.Option;

public class DiffrentTypeOptions {

	@Option(name = "/opt")
	private String option1;

	@Option(name = "--opt", aliases = "-o")
	private String option2;

	@Option(name = "opt")
	private String option3;

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
