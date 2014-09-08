package com.code4ge.jsf.args.handlers;

import java.net.MalformedURLException;
import java.net.URL;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

/**
 * Handles url type.
 * 
 * @author Daniel Stefaniuk
 */
public class URLHandler extends Handler<URL> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(new URL(value));
			}
			catch(MalformedURLException e) {
				throw new CmdLineException("Illegal URL value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing URL value");
		}
	}

}
