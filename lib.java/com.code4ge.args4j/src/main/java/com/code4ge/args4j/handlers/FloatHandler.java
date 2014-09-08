package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles float type.
 * 
 * @author Daniel Stefaniuk
 */
public class FloatHandler extends Handler<Float> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(Float.parseFloat(value));
			}
			catch(NumberFormatException e) {
				throw new CmdLineException("Illegal float value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing float value");
		}
	}

}
