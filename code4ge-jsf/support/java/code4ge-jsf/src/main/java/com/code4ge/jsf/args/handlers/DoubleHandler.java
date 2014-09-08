package com.code4ge.jsf.args.handlers;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

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
