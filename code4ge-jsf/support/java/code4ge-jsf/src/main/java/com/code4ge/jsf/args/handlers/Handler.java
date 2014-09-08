package com.code4ge.jsf.args.handlers;

import com.code4ge.jsf.args.CmdLineException;
import com.code4ge.jsf.args.RawParameters;

/**
 * Abstract handler type.
 * 
 * @author Daniel Stefaniuk
 */
public abstract class Handler<T> {

	private T value;

	public abstract void parse(RawParameters params) throws CmdLineException;

	public void setValue(T value) {

		this.value = value;
	}

	public T getValue() {

		return value;
	}

	public boolean isMultiValue() {

		return false;
	}

}
