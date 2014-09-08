package com.code4ge.jsf.mvc.model;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.beanutils.BeanMap;
import org.apache.commons.beanutils.PropertyUtilsBean;

/**
 * Model properties change detection.
 * 
 * @author Daniel Stefaniuk
 */
public class ModelDiff {

    private AbstractModel model1;

    private AbstractModel model2;

    public ModelDiff() {

    }

    public ModelDiff(AbstractModel model1, AbstractModel model2) {

        this.model1 = model1;
        this.model2 = model2;
    }

    public AbstractModel getModel1() {

        return model1;
    }

    public void setModel1(AbstractModel model1) {

        this.model1 = model1;
    }

    public AbstractModel getModel2() {

        return model2;
    }

    public void setModel2(AbstractModel model2) {

        this.model2 = model2;
    }

    public Map<String, Map<Integer, Object>> getDiff() {

        // See: http://stackoverflow.com/questions/6099040/find-out-the-differences-between-two-java-beans-for-version-tracking

        try {
            Map<String, Map<Integer, Object>> result = new HashMap<String, Map<Integer, Object>>();

            BeanMap map = new BeanMap(model1);
            PropertyUtilsBean pub = new PropertyUtilsBean();
            for(Object key: map.keySet()) {
                String name = (String) key;
                Object p1 = pub.getProperty(model1, name);
                Object p2 = pub.getProperty(model2, name);
                if(!p1.equals(p2)) {
                    Map<Integer, Object> diff = new HashMap<Integer, Object>();
                    diff.put(0, p1);
                    diff.put(0, p2);
                    result.put(name, diff);
                }
            }
        }
        catch(Exception e) {
            e.printStackTrace(System.err);
        }

        return null;
    }

}
