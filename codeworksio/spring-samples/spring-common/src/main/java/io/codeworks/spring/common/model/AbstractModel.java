package io.codeworks.spring.common.model;

import io.codeworks.spring.common.annotation.Sensitive;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public abstract class AbstractModel implements Cloneable, Serializable {

    private static final long serialVersionUID = 1L;

    public abstract Integer getId();

    public abstract void setId(Integer id);

    @Override
    public Object clone() throws CloneNotSupportedException {

        return super.clone();
    }

    @Override
    public String toString() {

        StringBuilder sb = new StringBuilder(this.getClass() + "@" + Integer.toHexString(this.hashCode()) + " ");

        Class<? extends AbstractModel> clazz = this.getClass();
        Field fields[] = clazz.getDeclaredFields();
        for(Field field: fields) {
            String name = field.getName();
            name = name.replace("_", "");
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
                Object object = method.invoke(this);
                if(object instanceof String) {
                    sb.append(name);
                    sb.append("=\"");
                    sb.append(field.getAnnotation(Sensitive.class) == null ? object : "******");
                    sb.append("\" ");
                }
                else {
                    sb.append(name);
                    sb.append("=");
                    sb.append(field.getAnnotation(Sensitive.class) == null ? object : "******");
                    sb.append(" ");
                }
            }
            catch(Exception e) {
            }
        }

        return sb.toString();
    }

}
