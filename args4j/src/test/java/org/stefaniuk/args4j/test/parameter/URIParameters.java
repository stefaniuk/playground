package org.stefaniuk.args4j.test.parameter;

import java.net.URI;

import org.stefaniuk.args4j.annotation.Argument;
import org.stefaniuk.args4j.annotation.Option;

public class URIParameters {

    @Argument(index = 0)
    private URI argument1;

    @Argument(index = 1)
    private URI argument2;

    @Argument(index = 2)
    private URI argument3;

    @Option(name = "/opt1")
    private URI option1;

    @Option(name = "/opt2")
    private URI option2;

    @Option(name = "/opt3")
    private URI option3;

    public URI getArgument1() {

        return argument1;
    }

    public URI getArgument2() {

        return argument2;
    }

    public URI getArgument3() {

        return argument3;
    }

    public URI getOption1() {

        return option1;
    }

    public URI getOption2() {

        return option2;
    }

    public URI getOption3() {

        return option3;
    }

}
