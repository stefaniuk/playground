package com.code4ge.args4j.annotations;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * Command line argument.
 * 
 * @author Daniel Stefaniuk
 */
@Retention(RUNTIME)
@Target({ FIELD, METHOD })
public @interface Argument {

	boolean required() default false;

	String usage() default "";

	String meta() default "";

	int index() default 0;

}
