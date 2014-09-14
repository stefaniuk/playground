package org.stefaniuk.args4j.test.parameter;

import org.stefaniuk.args4j.annotation.Argument;
import org.stefaniuk.args4j.annotation.Option;

public class LongParameters {

    @Argument(index = 0)
    private long argument1;

    @Argument(index = 1)
    private Long argument2;

    @Argument(index = 2)
    private long argument3;

    @Option(name = "/opt1")
    private long option1;

    @Option(name = "/opt2")
    private Long option2;

    @Option(name = "/opt3")
    private Long option3;

    public long getArgument1() {

        return argument1;
    }

    public Long getArgument2() {

        return argument2;
    }

    public long getArgument3() {

        return argument3;
    }

    public long getOption1() {

        return option1;
    }

    public Long getOption2() {

        return option2;
    }

    public Long getOption3() {

        return option3;
    }

}
