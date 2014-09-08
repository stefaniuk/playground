package com.code4ge.jsf.mvc.model;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

/**
 * Spring MVC abstract model.
 * 
 * @author Daniel Stefaniuk
 */
public abstract class AbstractModel {

    /**
     * Returns an identity key of the model.
     * 
     * @return
     */
    public abstract Integer getId();

    /**
     * Compares model to a give object (an instance of AbstractModel).
     * 
     * @param model
     * @return
     * @throws ModelException
     */
    public Map<String, Map<Integer, Object>> modelCompare(AbstractModel model) {

        // keys must match
        if(!getId().equals(model.getId())) {
            throw new ModelException("Cannot compare two models with different ID");
        }

        Class<? extends AbstractModel> c1 = this.getClass();
        Class<? extends AbstractModel> c2 = model.getClass();

        // classes must match
        if(!c1.equals(c2)) {
            throw new ModelException("Cannot compare two models of different classes");
        }

        Map<String, Map<Integer, Object>> result = new HashMap<String, Map<Integer, Object>>();

        if(c1.equals(c2) && c1.getAnnotation(ModelTable.class) != null && c2.getAnnotation(ModelTable.class) != null) {

            // get all the fields
            Field fs[] = c1.getDeclaredFields();
            for(Field f: fs) {

                // compare only field marked as ModelColumn
                Annotation a = f.getAnnotation(ModelColumn.class);
                if(a != null) {
                    String name = f.getName();
                    try {

                        // we need to invoke a getter to be able to compare
                        // values
                        String getterName = "get" + name.substring(0, 1).toUpperCase() + name.substring(1);
                        Method m1 = c1.getMethod(getterName);
                        Method m2 = c2.getMethod(getterName);
                        Object o1 = m1.invoke(this);
                        Object o2 = m2.invoke(model);

                        // check if two fields are different
                        if((o1 != null && !o1.equals(o2)) || (o2 != null && !o2.equals(o1))) {
                            Map<Integer, Object> diff = new HashMap<Integer, Object>();
                            diff.put(0, o1);
                            diff.put(1, o2);
                            result.put(name, diff);
                        }

                    }
                    catch(SecurityException e) {
                        e.printStackTrace();
                    }
                    catch(NoSuchMethodException e) {
                        e.printStackTrace();
                    }
                    catch(IllegalArgumentException e) {
                        e.printStackTrace();
                    }
                    catch(IllegalAccessException e) {
                        e.printStackTrace();
                    }
                    catch(InvocationTargetException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        return result;
    }

    /**
     * Returns database column name by given field name;
     * 
     * @param clazz
     * @param field
     * @return
     * @throws ModelException
     */
    public static String getColumnName(Class<? extends AbstractModel> clazz, String field) throws ModelException {

        String name = null;

        try {
            ModelColumn mc = clazz.getDeclaredField(field).getAnnotation(ModelColumn.class);

            // field must be marked as model column
            if(mc == null) {
                throw new ModelException("Cannot get column name of '" + field + "' filed");
            }

            name = mc.name();
        }
        catch(SecurityException e) {
            e.printStackTrace();
        }
        catch(NoSuchFieldException e) {
            e.printStackTrace();
        }

        return name;
    }

    @Override
    public String toString() {

        StringBuilder sb = new StringBuilder("model: " + this.getClass()
            + ", hash: "
            + Integer.toHexString(this.hashCode())
            + ", fields: \n");

        Class<? extends AbstractModel> clazz = this.getClass();
        Field fields[] = clazz.getDeclaredFields();
        for(Field field: fields) {
            String name = field.getName();
            name = name.replace("_", "");
            String getterName = "get" + name.substring(0, 1).toUpperCase() + name.substring(1);
            try {
                Method method = clazz.getMethod(getterName);
                Object object = method.invoke(this);
                sb.append("   " + name + ": " + object + "\n");
            }
            catch(Exception e) {
                e.printStackTrace();
            }
        }

        return sb.toString();
    }

}
