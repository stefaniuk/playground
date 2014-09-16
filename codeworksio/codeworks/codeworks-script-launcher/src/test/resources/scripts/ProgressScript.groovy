package io.codeworks.script.launcher.test

import java.util.List;

import io.codeworks.script.launcher.test.impl.Progress
import io.codeworks.script.launcher.test.impl.ProgressEventListener

import org.slf4j.Logger
import org.slf4j.LoggerFactory

class ProgressScript implements Progress {

    def Logger logger = LoggerFactory.getLogger(ProgressScript.class)

    def listeners = new ArrayList()

    def progress = 0

    void setListeners(List<ProgressEventListener> listeners) {

        this.listeners = listeners
    }

    int getProgress() {

        return progress
    }

    void progress() {

        logger.debug("progressing...")
        for(int i = 0; i < 10; i++) {
            progress++;
            listeners.each { listener ->
                listener.onProgress(this, progress)
            }
        }
    }

}
