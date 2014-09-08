package com.code4ge.jsf.mvc.model;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Database column name used by model.
 * 
 * @author Daniel Stefaniuk
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.FIELD })
@Documented
public @interface ModelColumn {

    String name();

    String description() default "";
}
