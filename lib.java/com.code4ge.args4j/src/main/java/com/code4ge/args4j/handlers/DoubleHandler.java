package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles double type.
 * 
 * @author Daniel Stefaniuk
 */
public class DoubleHandler extends Handler<Double> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(Double.parseDouble(value));
			}
			catch(NumberFormatException e) {
				throw new CmdLineException("Illegal double value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing double value");
		}
	}

}
