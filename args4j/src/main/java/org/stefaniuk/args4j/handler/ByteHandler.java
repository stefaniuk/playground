package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles byte type.
 * 
 * @author Daniel Stefaniuk
 */
public class ByteHandler extends Handler<Byte> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(Byte.parseByte(value));
            }
            catch(NumberFormatException e) {
                throw new CmdLineException("Illegal byte value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing byte value");
        }
    }

}
