package com.code4ge.args4j;

import java.io.File;
import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.code4ge.args4j.annotations.Argument;
import com.code4ge.args4j.annotations.Option;
import com.code4ge.args4j.handlers.BooleanHandler;
import com.code4ge.args4j.handlers.ByteHandler;
import com.code4ge.args4j.handlers.CharacterHandler;
import com.code4ge.args4j.handlers.DoubleHandler;
import com.code4ge.args4j.handlers.EnumHandler;
import com.code4ge.args4j.handlers.FileHandler;
import com.code4ge.args4j.handlers.FloatHandler;
import com.code4ge.args4j.handlers.Handler;
import com.code4ge.args4j.handlers.IntegerHandler;
import com.code4ge.args4j.handlers.LongHandler;
import com.code4ge.args4j.handlers.ShortHandler;
import com.code4ge.args4j.handlers.StringArrayHandler;
import com.code4ge.args4j.handlers.StringHandler;
import com.code4ge.args4j.handlers.URIHandler;
import com.code4ge.args4j.handlers.URLHandler;

/**
 * Command line parser.
 * 
 * @author Daniel Stefaniuk
 */
public class Parser {

	private static final Map<Class<?>, Class<? extends Handler<?>>> handlers =
		Collections.synchronizedMap(new HashMap<Class<?>, Class<? extends Handler<?>>>());

	static {
		registerHandlers();
	}

	private Object bean;

	private List<Parameter> arguments = new ArrayList<Parameter>();

	private List<Parameter> options = new ArrayList<Parameter>();

	private List<Parameter> list = new ArrayList<Parameter>();

	class SortArgumentsByIndex implements Comparator<Parameter> {

		@Override
		public int compare(Parameter p1, Parameter p2) {

			return p1.getIndex() - p2.getIndex();
		}

	}

	class SortOptionsByName implements Comparator<Parameter> {

		@Override
		public int compare(Parameter p1, Parameter p2) {

			return p1.getName().compareTo(p2.getName());
		}

	}

	public Parser(Class<?> clazz) throws InstantiationException, IllegalAccessException {

		this(clazz.newInstance());
	}

	public Parser(Object bean) throws InstantiationException, IllegalAccessException {

		this.bean = bean;

		Class<?> clazz = bean.getClass();

		for(Class<?> c = clazz; c != null; c = c.getSuperclass()) {

			if(c.getName().equals("java.lang.Object")) {
				break;
			}

			for(Method m: c.getDeclaredMethods()) {
				Argument a = m.getAnnotation(Argument.class);
				if(a != null) {
					Handler<?> h = getHandler(m.getReturnType());
					arguments.add(new Parameter(bean, a, m, h));
				}
				Option o = m.getAnnotation(Option.class);
				if(o != null) {
					Handler<?> h = getHandler(m.getReturnType());
					options.add(new Parameter(bean, o, m, h));
				}
			}

			for(Field f: c.getDeclaredFields()) {

				if(f.getName().startsWith("this$")) {
					break;
				}

				Argument a = f.getAnnotation(Argument.class);
				if(a != null) {
					Handler<?> h = getHandler(f.getType());
					arguments.add(new Parameter(bean, a, f, h));
				}
				Option o = f.getAnnotation(Option.class);
				if(o != null) {
					Handler<?> h = getHandler(f.getType());
					options.add(new Parameter(bean, o, f, h));
				}
			}

		}

		Collections.sort(arguments, new SortArgumentsByIndex());
		Collections.sort(options, new SortOptionsByName());
	}

	public void parse(String[] params) {

		try {
			list.clear();
			RawParameters rawParams = new RawParameters(params);
			String str;
			while((str = rawParams.next()) != null) {
				// get parameter
				Parameter param = match(str);
				// process multi value option
				if(param.isMultiValue()) {
					rawParams.next();
					int n = 0;
					Parameter p;
					do {
						n++;
						str = rawParams.next();
						if(str == null) {
							break;
						}
						p = matchOption(str);
					} while(p == null);
					rawParams.move(-(n + 1));
					for(int i = 0; i < n; i++) {
						rawParams.next();
						param.parse(rawParams);
					}
				}
				// process single value option
				else if(param.isOption()) {
					rawParams.next();
					param.parse(rawParams);
				}
				// process argument
				else {
					param.parse(rawParams);
				}
				// add parameter to the list
				list.add(param);
			}
		}
		catch(Exception e) {
			e.printStackTrace(System.out);
			// TODO: print help
		}
	}

	private Parameter match(String name) {

		Parameter param = null;
		param = matchOption(name);
		if(param == null) {
			param = matchArgument(name);
		}

		return param;
	}

	private Parameter matchOption(String name) {

		if(name == null) {
			return null;
		}

		// match option
		for(Parameter option: options) {
			// by name
			if(name.equals(option.getName())) {
				return option;
			}
			else {
				// by alias' name
				for(String alias: option.getAliases()) {
					if(name.equals(alias)) {
						return option;
					}
				}
			}
		}

		return null;
	}

	private Parameter matchArgument(String name) {

		// match argument
		for(Parameter argument: arguments) {
			if(!list.contains(argument)) {
				return argument;
			}
		}

		return null;
	}

	public Object getBean() {

		return bean;
	}

	private static void registerHandlers() {

		handlers.put(boolean.class, BooleanHandler.class);
		handlers.put(Boolean.class, BooleanHandler.class);
		handlers.put(byte.class, ByteHandler.class);
		handlers.put(Byte.class, ByteHandler.class);
		handlers.put(char.class, CharacterHandler.class);
		handlers.put(Character.class, CharacterHandler.class);
		handlers.put(double.class, DoubleHandler.class);
		handlers.put(Double.class, DoubleHandler.class);
		handlers.put(File.class, FileHandler.class);
		handlers.put(float.class, FloatHandler.class);
		handlers.put(Float.class, FloatHandler.class);
		handlers.put(int.class, IntegerHandler.class);
		handlers.put(Integer.class, IntegerHandler.class);
		handlers.put(long.class, LongHandler.class);
		handlers.put(Long.class, LongHandler.class);
		handlers.put(short.class, ShortHandler.class);
		handlers.put(Short.class, ShortHandler.class);
		handlers.put(String[].class, StringArrayHandler.class);
		handlers.put(String.class, StringHandler.class);
		handlers.put(URI.class, URIHandler.class);
		handlers.put(URL.class, URLHandler.class);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private static Handler<?> getHandler(Class<?> type) {

		try {
			Constructor<? extends Handler<?>> ctr = null;
			if(Enum.class.isAssignableFrom(type)) {
				return new EnumHandler(type);
			}
			else {
				Class<? extends Handler<?>> clazz = handlers.get(type);
				ctr = clazz.getConstructor();
			}

			return ctr.newInstance();
		}
		catch(Exception e) {
		}

		return null;
	}

	public static boolean hasArguments(Class<?> clazz) {

		return hasAnnotation(clazz, Argument.class);
	}

	public static boolean hasOptions(Class<?> clazz) {

		return hasAnnotation(clazz, Option.class);
	}

	public static boolean hasAnnotation(Class<?> clazz, Class<? extends Annotation> annotation) {

		if(clazz.getAnnotation(annotation) != null) {
			return true;
		}

		for(Field f: clazz.getFields()) {
			if(f.getAnnotation(annotation) != null) {
				return true;
			}
		}
		for(Method m: clazz.getMethods()) {
			if(m.getAnnotation(annotation) != null) {
				return true;
			}
		}

		return false;
	}

}
