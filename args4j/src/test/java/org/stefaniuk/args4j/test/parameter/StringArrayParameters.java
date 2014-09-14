package org.stefaniuk.args4j.test.parameter;

import org.stefaniuk.args4j.annotation.Option;

public class StringArrayParameters {

    @Option(name = "/opt1")
    private String[] option1;

    @Option(name = "/opt2")
    private String[] option2;

    @Option(name = "/opt3")
    private String[] option3;

    public String[] getOption1() {

        return option1;
    }

    public String[] getOption2() {

        return option2;
    }

    public String[] getOption3() {

        return option3;
    }

}
