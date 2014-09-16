package io.codeworks.commons.commons.util;

import io.codeworks.commons.commons.exception.CodeworksException;
import io.codeworks.commons.data.model.Model;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

/**
 * Hibernate generic utility methods.
 * 
 * @author Daniel Stefaniuk
 */
public class HibernateUtil {

    public static final String WILDCARD = "*";

    public static <T extends Model> DetachedCriteria convertModelToCriteria(T model) {

        DetachedCriteria criteria = DetachedCriteria.forClass(model.getClass());

        Class<?> clazz = model.getClass();
        Field fields[] = clazz.getDeclaredFields();
        for(Field field: fields) {
            String name = field.getName();
            if(name.equals("serialVersionUID")) {
                continue;
            }
            try {
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
                Object value = null;
                try {
                    value = method.invoke(model);
                }
                catch(Exception e) {
                }
                if(value != null) {
                    boolean isString = value instanceof String;
                    boolean exactMatch = isString && !((String) value).contains(WILDCARD);
                    if(!isString) {
                        criteria.add(Restrictions.eq(name, value));
                    }
                    else if(isString) {
                        if(exactMatch) {
                            criteria.add(Restrictions.eq(name, value).ignoreCase());
                        }
                        else {
                            criteria.add(Restrictions.ilike(name, ((String) value).replace(WILDCARD, "%")));
                        }
                    }
                }
            }
            catch(Exception e) {
                throw new CodeworksException("Cannot access field '" +
                    field.getName() + "' on " +
                    clazz.getName() + " object");
            }
        }

        return criteria;
    }

}
