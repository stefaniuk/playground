package com.code4ge.jsf.args.handlers;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

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
