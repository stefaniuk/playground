package com.code4ge.jsf.args.handlers;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

/**
 * Handles enum type.
 * 
 * @author Daniel Stefaniuk
 */
public class EnumHandler<T extends Enum<T>> extends Handler<T> {

	private Class<T> clazz;

	public EnumHandler(Class<T> clazz) {

		this.clazz = clazz;
	}

	@Override
	public void parse(RawParameters params) throws CmdLineException {

		String value = params.current();
		if(value != null) {
			for(T v: clazz.getEnumConstants()) {
				if(v.name().equalsIgnoreCase(value)) {
					setValue(v);
					break;
				}
			}
			if(getValue() == null) {
				throw new CmdLineException("Illegal enum value " + value);
			}
		}
		else {
			throw new CmdLineException("Missing enum value");
		}
	}

}
