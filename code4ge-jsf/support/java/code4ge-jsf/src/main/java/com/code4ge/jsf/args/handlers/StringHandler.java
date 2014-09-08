package com.code4ge.jsf.args.handlers;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

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
