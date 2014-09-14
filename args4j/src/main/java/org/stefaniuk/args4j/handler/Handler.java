package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Abstract handler type.
 * 
 * @author Daniel Stefaniuk
 */
public abstract class Handler<T> {

    private T value;

    public abstract void parse(CmdLineParameters params) throws CmdLineException;

    public void setValue(T value) {

        this.value = value;
    }

    public T getValue() {

        return value;
    }

    public boolean isMultiValue() {

        return false;
    }

}
