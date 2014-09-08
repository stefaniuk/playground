package com.code4ge.args4j;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;
import com.code4ge.args4j.handlers.Handler;

/**
 * Represents command line parameter.
 * 
 * @author Daniel Stefaniuk
 */
public class Parameter {

	public enum Type {
		ARGUMENT, OPTION
	};

	private Object bean;

	private Object annotation;

	private Object property;

	private Handler<?> handler;

	public Parameter(Object bean, Annotation annotation, Object property, Handler<?> handler) {

		this.bean = bean;
		this.annotation = annotation;
		this.property = property;
		this.handler = handler;
	}

	public void parse(RawParameters params) throws CmdLineException {

		handler.parse(params);

		try {
			if(property instanceof Method) {
				Method m = (Method) property;
				m.invoke(bean, handler.getValue());
			}
			else if(property instanceof Field) {
				Field f = (Field) property;
				try {
					f.set(bean, handler.getValue());
				}
				catch(IllegalAccessException iae) {
					f.setAccessible(true);
					f.set(bean, handler.getValue());
					f.setAccessible(false);
				}
			}
		}
		catch(Exception e) {

			e.printStackTrace();

			throw new CmdLineException(e.getCause());
		}
	}

	public Type getType() {

		if(annotation instanceof Argument) {
			return Type.ARGUMENT;
		}
		else {
			return Type.OPTION;
		}
	}

	public boolean isArgument() {

		return Type.ARGUMENT == getType();
	}

	public boolean isOption() {

		return Type.OPTION == getType();
	}

	public String getName() {

		return ((Option) annotation).name();
	}

	public String[] getAliases() {

		return ((Option) annotation).aliases();
	}

	public boolean isRequired() {

		if(isArgument()) {
			return ((Argument) annotation).required();
		}
		else {
			return ((Option) annotation).required();
		}
	}

	public String getUsage() {

		if(isArgument()) {
			return ((Argument) annotation).usage();
		}
		else {
			return ((Option) annotation).usage();
		}
	}

	public String getMeta() {

		if(isArgument()) {
			return ((Argument) annotation).meta();
		}
		else {
			return ((Option) annotation).meta();
		}
	}

	public int getIndex() {

		return ((Argument) annotation).index();
	}

	public boolean isMultiValue() {

		return handler.isMultiValue();
	}

}
