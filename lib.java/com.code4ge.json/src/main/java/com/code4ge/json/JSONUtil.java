package com.code4ge.json;

/**
 * Utility class.
 * 
 * @author Daniel Stefaniuk
 */
public class JSONUtil {

	/**
	 * Cleans JSON string from unnecessary things like for example comments.
	 * 
	 * @param json
	 * @return
	 */
	public static String clean(String json) {

		json = json.trim();
		json = json.replaceFirst("^(var[\\s]*)*[a-zA-Z0-9_]*[\\s]*[:=][\\s]*", "");
		json = json.replaceAll("//.*", "");
		json = json.replaceAll("/\\*[\\s\\S]*\\*/", "");

		return json;
	}

}
