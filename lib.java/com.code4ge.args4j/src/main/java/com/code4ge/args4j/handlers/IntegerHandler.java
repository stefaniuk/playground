package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles integer type.
 * 
 * @author Daniel Stefaniuk
 */
public class IntegerHandler extends Handler<Integer> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(Integer.parseInt(value));
			}
			catch(NumberFormatException e) {
				throw new CmdLineException("Illegal integer value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing integer value");
		}
	}

}
