package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles short type.
 * 
 * @author Daniel Stefaniuk
 */
public class ShortHandler extends Handler<Short> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(Short.parseShort(value));
            }
            catch(NumberFormatException e) {
                throw new CmdLineException("Illegal short value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing short value");
        }
    }

}
