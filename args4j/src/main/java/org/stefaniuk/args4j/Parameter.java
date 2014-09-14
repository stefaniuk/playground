package org.stefaniuk.args4j;

import java.io.File;
import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.URI;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stefaniuk.args4j.annotation.Argument;
import org.stefaniuk.args4j.annotation.Option;
import org.stefaniuk.args4j.exception.CmdLineException;
import org.stefaniuk.args4j.handler.BooleanHandler;
import org.stefaniuk.args4j.handler.ByteHandler;
import org.stefaniuk.args4j.handler.CharacterHandler;
import org.stefaniuk.args4j.handler.DoubleHandler;
import org.stefaniuk.args4j.handler.EnumHandler;
import org.stefaniuk.args4j.handler.FileHandler;
import org.stefaniuk.args4j.handler.FloatHandler;
import org.stefaniuk.args4j.handler.Handler;
import org.stefaniuk.args4j.handler.IntegerHandler;
import org.stefaniuk.args4j.handler.JSONHandler;
import org.stefaniuk.args4j.handler.LongHandler;
import org.stefaniuk.args4j.handler.ShortHandler;
import org.stefaniuk.args4j.handler.StringArrayHandler;
import org.stefaniuk.args4j.handler.StringHandler;
import org.stefaniuk.args4j.handler.URIHandler;
import org.stefaniuk.args4j.handler.URLHandler;

/**
 * Represents command line parameter.
 * 
 * @author Daniel Stefaniuk
 */
public class Parameter {

    private static final Map<Class<?>, Class<? extends Handler<?>>> handlers =
        Collections.synchronizedMap(new HashMap<Class<?>, Class<? extends Handler<?>>>());

    static {

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

    public enum Type {
        ARGUMENT, OPTION
    };

    private final Logger logger = LoggerFactory.getLogger(Parameter.class);

    private Object bean;

    private Object annotation;

    private Object property;

    private Handler<?> handler;

    @SuppressWarnings({ "rawtypes", "unchecked" })
    public Parameter(Object bean, Annotation annotation, Object property, Class<?> handlerClass) {

        this.bean = bean;
        this.annotation = annotation;
        this.property = property;

        // set handler
        try {
            Constructor<? extends Handler<?>> ctr = null;
            if(Enum.class.isAssignableFrom(handlerClass)) {
                this.handler = new EnumHandler(handlerClass);
            }
            else if(handlerClass.equals(JSONHandler.class)) {
                ctr = JSONHandler.class.getConstructor();
            }
            else {
                Class<? extends Handler<?>> clazz = handlers.get(handlerClass);
                ctr = clazz.getConstructor();
            }
            this.handler = ctr.newInstance();
        }
        catch(Exception e) {
        }

        // set additional settings for JSONHandler
        if(handlerClass.equals(JSONHandler.class)) {
            if(property instanceof Method) {
                ((JSONHandler) this.handler).setType(((Method) property).getReturnType());
            }
            if(property instanceof Field) {
                ((JSONHandler) this.handler).setType(((Field) property).getType());
            }
        }
    }

    public void parse(CmdLineParameters params) throws CmdLineException {

        handler.parse(params);

        try {
            if(property instanceof Method) {
                Method m = (Method) property;
                m.invoke(bean, handler.getValue());
                logger.debug("Set value " + handler.getValue() + " using method " + m.getName());
            }
            else if(property instanceof Field) {
                Field f = (Field) property;
                try {
                    f.set(bean, handler.getValue());
                    logger.debug("Set value " + handler.getValue() + " to field " + f.getName());
                }
                catch(IllegalAccessException iae) {
                    f.setAccessible(true);
                    f.set(bean, handler.getValue());
                    f.setAccessible(false);
                    logger.debug("Set value " + handler.getValue() + " to field " + f.getName());
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

        if(isArgument()) {
            return null;
        }
        else {
            return ((Option) annotation).name();
        }
    }

    public String[] getAliases() {

        if(isArgument()) {
            return null;
        }
        else {
            return ((Option) annotation).aliases();
        }
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
            return ((Argument) annotation).description();
        }
        else {
            return ((Option) annotation).description();
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

        if(isArgument()) {
            return ((Argument) annotation).index();
        }
        else {
            return -1;
        }
    }

    public boolean isMultiValue() {

        return handler.isMultiValue();
    }

}
