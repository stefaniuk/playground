package io.codeworks.commons.data.model;

import io.codeworks.commons.commons.exception.CodeworksException;
import io.codeworks.commons.commons.util.ObjectUtil;
import io.codeworks.commons.data.annotation.DoNotShow;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * An abstract class that provides basic functionality for all models. This
 * includes ability to create a deep copy of the object and to produce its
 * string representation.
 * 
 * @author Daniel Stefaniuk
 */
public abstract class Model implements Cloneable, Serializable {

    private static final long serialVersionUID = 879894525855080178L;

    public abstract Long getId();

    public abstract void setId(Long id);

    @Override
    public Object clone() {

        return ObjectUtil.clone(this);
    }

    @Override
    public boolean equals(Object obj) {

        if(this == obj) {
            return true;
        }

        if(this.getId() == null || obj == null || !(this.getClass().equals(obj.getClass()))) {
            return false;
        }

        Model that = (Model) obj;

        return this.getId().equals(that.getId());
    }

    @Override
    public int hashCode() {

        return getId() == null ? 0 : getId().hashCode();
    }

    @Override
    public String toString() {

        StringBuilder sb = new StringBuilder(this.getClass() + "@" + Integer.toHexString(this.hashCode()) + " ");

        Class<? extends Model> clazz = this.getClass();
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
                Object object = null;
                try {
                    object = method.invoke(this);
                }
                catch(Exception e) {
                }
                if(object != null) {
                    sb.append(name);
                    if(object instanceof Model) {
                        sb.append("=[ ");
                        sb.append(object.toString());
                        sb.append("] ");
                    }
                    else if(object instanceof String || object instanceof Enum) {
                        sb.append("=\"");
                        sb.append(getValue(field, object));
                        sb.append("\" ");
                    }
                    else {
                        sb.append("=");
                        sb.append(getValue(field, object));
                        sb.append(" ");
                    }
                }
            }
            catch(Exception e) {
                throw new CodeworksException("Cannot access field '" +
                    field.getName() + "' on " +
                    clazz.getName() + " object", e);
            }
        }
        sb.deleteCharAt(sb.length() - 1);

        return sb.toString();
    }

    private Object getValue(Field field, Object obj) {

        Object val = field.getAnnotation(DoNotShow.class) == null ? obj : "******";

        return val;
    }

}
