package com.code4ge.jsf.args.handlers;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

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
