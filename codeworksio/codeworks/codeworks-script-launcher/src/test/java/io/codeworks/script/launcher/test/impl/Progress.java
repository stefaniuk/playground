package io.codeworks.script.launcher.test.impl;

import io.codeworks.script.launcher.Runner;

public interface Progress extends Runner<ProgressEventListener<?>> {

    public int getProgress();

    public void progress();

}
