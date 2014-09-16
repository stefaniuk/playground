package io.codeworks.commons.commons.util;

import io.codeworks.commons.commons.exception.CodeworksException;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

/**
 * Object generic utility methods.
 * 
 * @author Daniel Stefaniuk
 */
public class ObjectUtil {

    @SuppressWarnings("unchecked")
    public static <T> T clone(final T object) {

        T newObject = null;

        try {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            ObjectOutputStream out = new ObjectOutputStream(bos);
            out.writeObject(object);
            out.flush();
            out.close();
            ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bos.toByteArray()));
            newObject = (T) in.readObject();
        }
        catch(Exception e) {
            throw new CodeworksException("Unable to clone the object", e);
        }

        return newObject;
    }

    @SuppressWarnings("unchecked")
    public static <T> void copyBeanProperties(final T source, final T target) {

        List<String> properties = new ArrayList<>();

        Class<T> clazz = (Class<T>) target.getClass();
        Field fields[] = clazz.getDeclaredFields();
        for(Field field: fields) {
            String name = field.getName();
            if(name.equals("serialVersionUID")) {
                continue;
            }
            Method method = null;
            try {
                method = clazz.getMethod("get" + name.substring(0, 1).toUpperCase() + name.substring(1));
            }
            catch(Exception e1) {
                try {
                    method = clazz.getMethod("is" + name.substring(0, 1).toUpperCase() + name.substring(1));
                }
                catch(Exception e2) {
                }
            }
            if(method != null) {
                properties.add(name);
            }
        }

        copyBeanProperties(source, target, properties);
    }

    public static void copyBeanProperties(final Object source, final Object target, Iterable<String> properties) {

        BeanWrapper bwSource = new BeanWrapperImpl(source);
        BeanWrapper bwTarget = new BeanWrapperImpl(target);

        for(String property: properties) {
            Object obj = bwSource.getPropertyValue(property);
            if(obj != null) {
                bwTarget.setPropertyValue(property, obj);
            }
        }
    }

}
