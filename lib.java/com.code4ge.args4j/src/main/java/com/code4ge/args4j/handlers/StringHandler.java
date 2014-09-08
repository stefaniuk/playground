package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles string type.
 * 
 * @author Daniel Stefaniuk
 */
public class StringHandler extends Handler<String> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			setValue(value);
		}
		else {
			throw new CmdLineException("Missing string value");
		}
	}

}
