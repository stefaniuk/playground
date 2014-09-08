package com.code4ge.jsf.args.handlers;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

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
