package org.stefaniuk.args4j.handler;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.stefaniuk.args4j.CmdLineParameters;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Handles string array type.
 * 
 * @author Daniel Stefaniuk
 */
public class StringArrayHandler extends Handler<String[]> {

    @Override
    public void parse(CmdLineParameters params) throws CmdLineException {

        // get already stored array
        List<String> list;
        String[] values = getValue();
        if(values == null) {
            list = new ArrayList<String>();
        }
        else {
            list = new ArrayList<String>(Arrays.asList(values));
        }

        // add current value
        list.add(params.current());

        // set array
        values = new String[list.size()];
        list.toArray(values);
        setValue(values);
    }

    @Override
    public boolean isMultiValue() {

        return true;
    }

}
