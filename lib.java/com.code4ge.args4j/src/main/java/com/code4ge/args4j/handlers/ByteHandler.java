package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles byte type.
 * 
 * @author Daniel Stefaniuk
 */
public class ByteHandler extends Handler<Byte> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(Byte.parseByte(value));
			}
			catch(NumberFormatException e) {
				throw new CmdLineException("Illegal byte value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing byte value");
		}
	}

}
