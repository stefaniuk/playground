package io.codeworks.file.monitor.core.test.impl;

import io.codeworks.file.monitor.core.FileMonitorEventListener;

import java.nio.file.Path;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent.Kind;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FileMonitorEventListenerImpl implements FileMonitorEventListener {

    private static Logger logger = LoggerFactory.getLogger(FileMonitorEventListenerImpl.class);

    @Override
    public void action(Path entry, Kind<Path> event) {

        if(event == StandardWatchEventKinds.ENTRY_CREATE) {
            logger.debug("create " + entry);
        }
        else if(event == StandardWatchEventKinds.ENTRY_DELETE) {
            logger.debug("delete " + entry);
        }
        else if(event == StandardWatchEventKinds.ENTRY_MODIFY) {
            logger.debug("modify " + entry);
        }
    }

}
