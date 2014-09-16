package io.codeworks.commons.data.annotation;

import static java.lang.annotation.ElementType.FIELD;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Value of a field with this annotation will be replaced while converting to
 * string.
 * 
 * @author Daniel Stefaniuk
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ FIELD })
@Documented
public @interface DoNotShow {

}
