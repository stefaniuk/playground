package com.code4ge.args4j;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;

/**
 * Represents command line raw parameters.
 * 
 * @author Daniel Stefaniuk
 */
public class RawParameters {

	public static final String WRAPPER = "\"";

	private final List<String> rawParams = new ArrayList<String>();

	private int pos = -1;

	public RawParameters(String[] params) {

		for(String arg: params) {
			int idx = arg.indexOf("=");
			if(idx > 0) {
				rawParams.add(arg.substring(0, idx));
				String value = arg.substring(idx + 1);
				if(value.startsWith("\"") && value.endsWith("\"")) {
					if(value.contains("\",\"")) {
						value = StringUtils.strip(value, WRAPPER);
						String[] values = value.split("\",\"");
						for(String v: values) {
							rawParams.add(v);
						}
					}
					else {
						rawParams.add(StringUtils.strip(value, WRAPPER));
					}
				}
				else {
					if(value.contains(",")) {
						value = StringUtils.strip(value, WRAPPER);
						String[] values = value.split(",");
						for(String v: values) {
							rawParams.add(v);
						}
					}
					else {
						rawParams.add(StringUtils.strip(value, WRAPPER));
					}
				}
			}
			else {
				rawParams.add(arg);
			}
		}
	}

	public String next() {

		if(pos + 1 < rawParams.size()) {
			return rawParams.get(++pos);
		}
		else {
			pos = rawParams.size();
		}

		return null;
	}

	public String current() throws CmdLineException {

		if(pos < 0 || pos > rawParams.size() - 1) {
			throw new CmdLineException("Index out of Bound");
		}

		return rawParams.get(pos);
	}

	public void move(int n) throws CmdLineException {

		int idx = pos + n;
		if(idx < 0 || idx > rawParams.size() - 1) {
			throw new CmdLineException("Index out of Bound");
		}

		pos = idx;
	}

	public void rewind() {

		pos = -1;
	}

	@Override
	public String toString() {

		StringBuilder sb = new StringBuilder();

		for(String param: rawParams) {
			sb.append(param);
			sb.append(" ");
		}

		return sb.toString();
	}

}
