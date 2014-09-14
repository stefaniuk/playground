package org.stefaniuk.args4j.test.parameter;

import org.stefaniuk.args4j.annotation.Argument;
import org.stefaniuk.args4j.annotation.Option;

public class BooleanParameters {

    @Argument(index = 0)
    private boolean argument1;

    @Argument(index = 1)
    private Boolean argument2;

    @Argument(index = 2)
    private boolean argument3;

    @Option(name = "/opt1")
    private boolean option1;

    @Option(name = "/opt2")
    private Boolean option2;

    @Option(name = "/opt3")
    private Boolean option3;

    public boolean getArgument1() {

        return argument1;
    }

    public Boolean getArgument2() {

        return argument2;
    }

    public boolean getArgument3() {

        return argument3;
    }

    public boolean getOption1() {

        return option1;
    }

    public Boolean getOption2() {

        return option2;
    }

    public Boolean getOption3() {

        return option3;
    }

}
