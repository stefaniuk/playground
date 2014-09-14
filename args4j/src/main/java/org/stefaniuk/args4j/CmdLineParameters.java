package org.stefaniuk.args4j;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stefaniuk.args4j.exception.CmdLineException;

/**
 * Represents command line raw parameters.
 * 
 * @author Daniel Stefaniuk
 */
public class CmdLineParameters {

    public static final String WRAPPER = "\"";

    private final Logger logger = LoggerFactory.getLogger(CmdLineParameters.class);

    private final List<String> cmdLineParams = new ArrayList<String>();

    private int pos = -1;

    public CmdLineParameters(boolean hasJsonParameters, String[] params) {

        for(String arg: params) {
            int idx = arg.indexOf("=");
            if(idx > 0) {
            	logger.debug("Found string " + arg.substring(0, idx));
                cmdLineParams.add(arg.substring(0, idx));
                String value = arg.substring(idx + 1);
                if(value.startsWith("\"") && value.endsWith("\"") && !hasJsonParameters) {
                    if(value.contains("\",\"")) {
                        value = StringUtils.strip(value, WRAPPER);
                        String[] values = value.split("\",\"");
                        for(String v: values) {
                        	logger.debug("Found string " + v);
                            cmdLineParams.add(v);
                        }
                    }
                    else {
                    	String v = StringUtils.strip(value, WRAPPER);
                    	logger.debug("Found string " + v);
                        cmdLineParams.add(v);
                    }
                }
                else {
                    if(value.contains(",") && !hasJsonParameters) {
                        value = StringUtils.strip(value, WRAPPER);
                        String[] values = value.split(",");
                        for(String v: values) {
                        	logger.debug("Found string " + v);
                            cmdLineParams.add(v);
                        }
                    }
                    else {
                    	String v = StringUtils.strip(value, WRAPPER);
                    	logger.debug("Found string " + v);
                        cmdLineParams.add(v);
                    }
                }
            }
            else {
            	logger.debug("Found string " + arg);
                cmdLineParams.add(arg);
            }
        }
    }

    public String next() {

        if(pos + 1 < cmdLineParams.size()) {
            return cmdLineParams.get(++pos);
        }
        else {
            pos = cmdLineParams.size();
        }

        return null;
    }

    public String current() throws CmdLineException {

        if(pos < 0 || pos > cmdLineParams.size() - 1) {
            throw new CmdLineException("Index out of Bound");
        }

        return cmdLineParams.get(pos);
    }

    public void move(int n) throws CmdLineException {

        int idx = pos + n;
        if(idx < 0 || idx > cmdLineParams.size() - 1) {
            throw new CmdLineException("Index out of Bound");
        }

        pos = idx;
    }

    public void rewind() {

        pos = -1;
    }

    @Override
    public String toString() {

        StringBuilder sb = new StringBuilder();

        for(String param: cmdLineParams) {
            sb.append(param);
            sb.append(" ");
        }

        return sb.toString();
    }

}
