package org.stefaniuk.args4j.handler;

import java.net.URI;
import java.net.URISyntaxException;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles URI type.
 * 
 * @author Daniel Stefaniuk
 */
public class URIHandler extends Handler<URI> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(new URI(value));
            }
            catch(URISyntaxException e) {
                throw new CmdLineException("Illegal URI value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing URI value");
        }
    }

}
