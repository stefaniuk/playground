package io.codeworks.script.launcher.test.impl;

import io.codeworks.script.launcher.RunnerEventListener;

import java.lang.reflect.Method;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProgressEventListener<T extends Progress> implements RunnerEventListener<T> {

    private static Logger logger = LoggerFactory.getLogger(ProgressEventListener.class);

    @Override
    public void onLoad(Class<T> clazz) {

        logger.debug("on load");
    }

    @Override
    public void onCreate(T instance) {

        logger.debug("on create");
    }

    @Override
    public void onRun(T instance, Method method, Object... arguments) {

        logger.debug("on run");
    }

    public void onProgress(T instance, int progress) {

        logger.debug("on progress");
    }

}
