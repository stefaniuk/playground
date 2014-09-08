package com.code4ge.args4j.annotations;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

/**
 * Command line option.
 * 
 * @author Daniel Stefaniuk
 */
@Retention(RUNTIME)
@Target({ FIELD, METHOD })
public @interface Option {

	String name() default "";

	String[] aliases() default {};

	boolean required() default false;

	String usage() default "";

	String meta() default "";

}
