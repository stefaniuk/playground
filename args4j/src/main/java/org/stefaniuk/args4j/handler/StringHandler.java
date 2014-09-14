package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles string type.
 * 
 * @author Daniel Stefaniuk
 */
public class StringHandler extends Handler<String> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            setValue(value);
        }
        else {
            throw new CmdLineException("Missing string value");
        }
    }

}
