package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles long type.
 * 
 * @author Daniel Stefaniuk
 */
public class LongHandler extends Handler<Long> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(Long.parseLong(value));
			}
			catch(NumberFormatException e) {
				throw new CmdLineException("Illegal long value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing long value");
		}
	}

}
