package com.code4ge.jsf.args.handlers;

import java.net.URI;
import java.net.URISyntaxException;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

/**
 * Handles uri type.
 * 
 * @author Daniel Stefaniuk
 */
public class URIHandler extends Handler<URI> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			try {
				setValue(new URI(value));
			}
			catch(URISyntaxException e) {
				throw new CmdLineException("Illegal URI value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing URI value");
		}
	}

}
