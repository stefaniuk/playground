package com.code4ge.jsf.args.handlers;

import java.io.File;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

/**
 * Handles file type.
 * 
 * @author Daniel Stefaniuk
 */
public class FileHandler extends Handler<File> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			setValue(new File(value));
		}
		else {
			throw new CmdLineException("Missing file value");
		}
	}

}
