package org.stefaniuk.args4j.annotation;

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

	int index() default 0;

	boolean required() default false;

	String description() default "";

	String meta() default "";

	Class<?> handler() default Object.class;

}
