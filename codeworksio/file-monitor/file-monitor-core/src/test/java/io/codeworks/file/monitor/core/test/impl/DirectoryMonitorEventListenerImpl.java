package io.codeworks.file.monitor.core.test.impl;

import io.codeworks.file.monitor.core.DirectoryMonitorEventListener;

import java.nio.file.Path;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent.Kind;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DirectoryMonitorEventListenerImpl implements DirectoryMonitorEventListener {

    private static Logger logger = LoggerFactory.getLogger(DirectoryMonitorEventListenerImpl.class);

    @Override
    public void action(Path dir, Path cause, Kind<Path> event) {

        if(event == StandardWatchEventKinds.ENTRY_CREATE) {
            logger.debug("create " + cause);
        }
        else if(event == StandardWatchEventKinds.ENTRY_DELETE) {
            logger.debug("delete " + cause);
        }
        else if(event == StandardWatchEventKinds.ENTRY_MODIFY) {
            logger.debug("modify " + cause);
        }
    }

}
