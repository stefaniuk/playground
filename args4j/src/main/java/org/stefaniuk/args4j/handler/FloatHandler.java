package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles float type.
 * 
 * @author Daniel Stefaniuk
 */
public class FloatHandler extends Handler<Float> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(Float.parseFloat(value));
            }
            catch(NumberFormatException e) {
                throw new CmdLineException("Illegal float value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing float value");
        }
    }

}
