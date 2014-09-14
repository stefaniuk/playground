package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles integer type.
 * 
 * @author Daniel Stefaniuk
 */
public class IntegerHandler extends Handler<Integer> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(Integer.parseInt(value));
            }
            catch(NumberFormatException e) {
                throw new CmdLineException("Illegal integer value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing integer value");
        }
    }

}
