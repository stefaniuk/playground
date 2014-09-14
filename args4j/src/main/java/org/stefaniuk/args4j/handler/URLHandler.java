package org.stefaniuk.args4j.handler;

import java.net.MalformedURLException;
import java.net.URL;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles URL type.
 * 
 * @author Daniel Stefaniuk
 */
public class URLHandler extends Handler<URL> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        String value = params.current();
        if(value != null) {
            try {
                setValue(new URL(value));
            }
            catch(MalformedURLException e) {
                throw new CmdLineException("Illegal URL value " + value);
            }
        }
        else {
            throw new CmdLineException("Missing URL value");
        }
    }

}
