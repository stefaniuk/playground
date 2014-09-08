package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles short type.
 * 
 * @author Daniel Stefaniuk
 */
public class ShortHandler extends Handler<Short> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(Short.parseShort(value));
			}
			catch(NumberFormatException e) {
				throw new CmdLineException("Illegal short value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing short value");
		}
	}

}
