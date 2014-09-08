package com.code4ge.jsf.util;

import java.util.Properties;

public class Configuration extends Properties {

    // TODO: for now is OK, but in the future more advanced configuration object may be needed

    private static final long serialVersionUID = 1L;

    public Configuration() {

    }

    public void setProperties(Properties properties) {

        for(Object obj: properties.keySet()) {
            String key = (String) obj;
            String value = (String) properties.get(key);
            this.put(key, value);
        }
    }

}
