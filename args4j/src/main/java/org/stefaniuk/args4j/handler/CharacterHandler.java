package org.stefaniuk.args4j.handler;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles character type.
 * 
 * @author Daniel Stefaniuk
 */
public class CharacterHandler extends Handler<Character> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            if(value.length() != 1) {
                throw new CmdLineException("Illegal character value " + value);
            }
            setValue(value.charAt(0));
        }
        else {
            throw new CmdLineException("Missing character value");
        }
    }

}
