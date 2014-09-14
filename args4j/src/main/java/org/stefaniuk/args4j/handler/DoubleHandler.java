package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles double type.
 * 
 * @author Daniel Stefaniuk
 */
public class DoubleHandler extends Handler<Double> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(Double.parseDouble(value));
            }
            catch(NumberFormatException e) {
                throw new CmdLineException("Illegal double value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing double value");
        }
    }

}
