package org.stefaniuk.args4j.handler;

import java.util.Arrays;
import java.util.List;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles boolean type.
 * 
 * @author Daniel Stefaniuk
 */
public class BooleanHandler extends Handler<Boolean> {

    private static final List<String> ACCEPTABLE_VALUES = Arrays.asList(new String[] {
        "true", "false",
        "on", "off",
        "yes", "no",
        "1", "0"
    });

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            int index = ACCEPTABLE_VALUES.indexOf(value);
            if(index == -1) {
                throw new CmdLineException("Illegal boolean value " + value);
            }
            else {
                setValue(Boolean.valueOf(index % 2 == 0));
            }
        }
        else {
            throw new CmdLineException("Missing boolean value");
        }
    }

}
