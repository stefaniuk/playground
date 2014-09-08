package com.code4ge.args4j.handlers;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles character type.
 * 
 * @author Daniel Stefaniuk
 */
public class CharacterHandler extends Handler<Character> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			if(value.length() != 1) {
				throw new CmdLineException("Illegal character value " + value);
			}
			setValue(value.charAt(0));
		}
		else {
			throw new CmdLineException("Missing character value");
		}
	}

}
