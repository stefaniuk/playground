package com.code4ge.args4j.handlers;

import java.util.Arrays;
import java.util.List;

import com.code4ge.args4j.CmdLineException;
import com.code4ge.args4j.RawParameters;

/**
 * Handles boolean type.
 * 
 * @author Daniel Stefaniuk
 */
public class BooleanHandler extends Handler<Boolean> {

	private static final List<String> ACCEPTABLE_VALUES = Arrays.asList(new String[] {
		"true", "false",
		"on", "off",
		"yes", "no",
		"1", "0"
	});

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			int index = ACCEPTABLE_VALUES.indexOf(value);
			if(index == -1) {
				throw new CmdLineException("Illegal boolean value " + value);
			}
			else {
				setValue(Boolean.valueOf(index % 2 == 0));
			}
		}
		else {
			throw new CmdLineException("Missing boolean value");
		}
	}

}
