package org.stefaniuk.args4j.handler;

import java.io.File;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles file type.
 * 
 * @author Daniel Stefaniuk
 */
public class FileHandler extends Handler<File> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            setValue(new File(value));
        }
        else {
            throw new CmdLineException("Missing file value");
        }
    }

}
