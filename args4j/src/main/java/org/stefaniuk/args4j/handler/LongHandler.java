package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles long type.
 * 
 * @author Daniel Stefaniuk
 */
public class LongHandler extends Handler<Long> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(Long.parseLong(value));
            }
            catch(NumberFormatException e) {
                throw new CmdLineException("Illegal long value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing long value");
        }
    }

}
