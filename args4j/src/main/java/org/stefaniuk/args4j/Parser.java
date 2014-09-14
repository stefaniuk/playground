package org.stefaniuk.args4j;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stefaniuk.args4j.annotation.Argument;
import org.stefaniuk.args4j.annotation.Option;
import org.stefaniuk.args4j.handler.JSONHandler;

/**
 * Command line parser.
 * 
 * @author Daniel Stefaniuk
 */
public class Parser {

    private final Logger logger = LoggerFactory.getLogger(Parser.class);

    private List<Parameter> arguments = new ArrayList<Parameter>();

    private List<Parameter> options = new ArrayList<Parameter>();

    private List<Parameter> list = new ArrayList<Parameter>();

    private boolean hasJsonParameters = false;

    class SortArgumentsByIndex implements Comparator<Parameter> {

        public int compare(Parameter p1, Parameter p2) {

            return p1.getIndex() - p2.getIndex();
        }

    }

    class SortOptionsByName implements Comparator<Parameter> {

        public int compare(Parameter p1, Parameter p2) {

            return p1.getName().compareTo(p2.getName());
        }

    }

    public Parser(Class<?> clazz) throws InstantiationException, IllegalAccessException {

        this(clazz.newInstance());
    }

    public Parser(Object bean) throws InstantiationException, IllegalAccessException {

        Class<?> clazz = bean.getClass();

        logger.debug("Parser option class " + clazz.getCanonicalName());

        // check whole inheritance tree
        for(Class<?> c = clazz; c != null; c = c.getSuperclass()) {

            if(c.getName().equals("java.lang.Object")) {
                break;
            }

            // scan methods
            for(Method m: c.getDeclaredMethods()) {
                Argument a = m.getAnnotation(Argument.class);
                if(a != null) {
                    // check if handler is given by annotation first
                    Class<?> handlerClass = a.handler();
                    logger.debug("Handler class: " + handlerClass.getCanonicalName());
                    if(handlerClass.equals(Object.class)) {
                        // determine handler by method return type
                        handlerClass = m.getReturnType();
                    }
                    if(handlerClass.equals(JSONHandler.class)) {
                        hasJsonParameters = true;
                    }
                    arguments.add(new Parameter(bean, a, m, handlerClass));
                }
                Option o = m.getAnnotation(Option.class);
                if(o != null) {
                    // check if handler is given by annotation first
                    Class<?> handlerClass = o.handler();
                    logger.debug("Handler class: " + handlerClass.getCanonicalName());
                    if(handlerClass.equals(Object.class)) {
                        // determine handler by method return type
                        handlerClass = m.getReturnType();
                    }
                    if(handlerClass.equals(JSONHandler.class)) {
                        hasJsonParameters = true;
                    }
                    options.add(new Parameter(bean, o, m, handlerClass));
                }
            }

            // scan fields
            for(Field f: c.getDeclaredFields()) {

                if(f.getName().startsWith("this$")) {
                    break;
                }

                Argument a = f.getAnnotation(Argument.class);
                if(a != null) {
                    // check if handler is given by annotation first
                    Class<?> handlerClass = a.handler();
                    logger.debug("Handler class: " + handlerClass.getCanonicalName());
                    if(handlerClass.equals(Object.class)) {
                        // determine handler by field type
                        handlerClass = f.getType();
                    }
                    if(handlerClass.equals(JSONHandler.class)) {
                        hasJsonParameters = true;
                    }
                    arguments.add(new Parameter(bean, a, f, handlerClass));
                }
                Option o = f.getAnnotation(Option.class);
                if(o != null) {
                    // check if handler is given by annotation first
                    Class<?> handlerClass = o.handler();
                    logger.debug("Handler class: " + handlerClass.getCanonicalName());
                    if(handlerClass.equals(Object.class)) {
                        // determine handler by field type
                        handlerClass = f.getType();
                    }
                    if(handlerClass.equals(JSONHandler.class)) {
                        hasJsonParameters = true;
                    }
                    options.add(new Parameter(bean, o, f, handlerClass));
                }
            }

        }

        Collections.sort(arguments, new SortArgumentsByIndex());
        Collections.sort(options, new SortOptionsByName());
    }

    public void parse(String[] params) {

        try {
            list.clear();
            CmdLineParameters cmdLineParams = new CmdLineParameters(hasJsonParameters, params);
            String str;
            while((str = cmdLineParams.next()) != null) {
                // get parameter
                logger.debug("Match parameter: " + str);
                Parameter param = match(str);
                // process multi-value option
                if(param.isMultiValue()) {
                    cmdLineParams.next();
                    int n = 0;
                    Parameter p;
                    do {
                        n++;
                        str = cmdLineParams.next();
                        if(str == null) {
                            break;
                        }
                        p = matchOption(str);
                    } while(p == null);
                    cmdLineParams.move(-(n + 1));
                    for(int i = 0; i < n; i++) {
                        cmdLineParams.next();
                        param.parse(cmdLineParams);
                    }
                }
                // process single value option
                else if(param.isOption()) {
                    cmdLineParams.next();
                    param.parse(cmdLineParams);
                }
                // process argument
                else {
                    param.parse(cmdLineParams);
                }
                // add parameter to the list
                list.add(param);
            }
        }
        catch(Exception e) {
            e.printStackTrace(System.out);
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
                logger.debug("Match option name " + option.getName());
                return option;
            }
            else {
                // by alias' name
                for(String alias: option.getAliases()) {
                    if(name.equals(alias)) {
                        logger.debug("Match option alias " + option.getName());
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
                logger.debug("Match argument number " + argument.getIndex());
                return argument;
            }
        }

        return null;
    }

}
