package com.code4ge.jsf.args.handlers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

/**
 * Handles string array type.
 * 
 * @author Daniel Stefaniuk
 */
public class StringArrayHandler extends Handler<String[]> {

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		// get already stored array
		List<String> list;
		String[] values = getValue();
		if(values == null) {
			list = new ArrayList<String>();
		}
		else {
			list = new ArrayList<String>(Arrays.asList(values));
		}

		// add current value
		list.add(params.current());

		// set array
		values = new String[list.size()];
		list.toArray(values);
		setValue(values);
	}

	@Override
	public boolean isMultiValue() {

		return true;
	}

}
