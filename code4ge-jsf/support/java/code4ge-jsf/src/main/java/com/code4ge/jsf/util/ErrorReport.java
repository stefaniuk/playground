package com.code4ge.jsf.util;

import java.lang.reflect.InvocationTargetException;

/**
 * Error reporting class.
 * 
 * @author Daniel Stefaniuk
 */
public class ErrorReport {

    public static String getFullStackTrace(Exception e) {

        Throwable t = e;
        if(t instanceof InvocationTargetException) {
            t = t.getCause();
        }

        String str = "Error in class: " +
            t.getStackTrace()[0].getClassName() + "." +
            t.getStackTrace()[0].getMethodName() + " (" +
            t.getStackTrace()[0].getFileName() + ":" +
            t.getStackTrace()[0].getLineNumber() + ")";

        // get stack trace
        StackTraceElement[] aSte = t.getStackTrace();
        str = str + "\n\n";
        for(int i = 0; i < aSte.length; i++) {
            str += aSte[i];
            str += "\n";
        }

        return str;
    }

}
