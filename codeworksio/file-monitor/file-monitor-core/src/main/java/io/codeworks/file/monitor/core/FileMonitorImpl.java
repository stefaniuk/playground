package io.codeworks.file.monitor.core;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.WatchEvent.Kind;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FileMonitorImpl implements FileMonitor {

    private static Logger logger = LoggerFactory.getLogger(FileMonitorImpl.class);

    private List<FileMonitorEventListener> listeners = new ArrayList<>();

    private List<Path> entries = new ArrayList<>();

    private Map<Path, DirectoryMonitor> monitors = new HashMap<>();

    public FileMonitorImpl() {

    }

    public FileMonitorImpl(FileMonitorEventListener listener) {

        listeners.add(listener);
    }

    public FileMonitorImpl(Path entry, FileMonitorEventListener listener) {

        addListener(listener);
        add(entry);
    }

    public FileMonitorImpl(List<Path> entries, FileMonitorEventListener listener) {

        addListener(listener);
        add(entries);
    }

    @Override
    public void start() {

        logger.debug("start file monitor");

        for(Path entry: entries) {
            monitor(entry);
        }
    }

    @Override
    public void stop() {

        for(Path entry: entries) {
            unmonitor(entry);
        }

        logger.debug("stop file monitor");
    }

    @Override
    public void addListener(FileMonitorEventListener listener) {

        listeners.add(listener);
    }

    @Override
    public void removeListener(FileMonitorEventListener listener) {

        listeners.remove(listener);
    }

    @Override
    public void add(Path entry) {

        if(!entries.contains(entry)) {
            entries.add(entry);
            monitor(entry);
        }
    }

    @Override
    public void add(List<Path> entries) {

        for(Path entry: entries) {
            add(entry);
        }
    }

    @Override
    public void remove(Path entry) {

        if(entries.contains(entry)) {
            unmonitor(entry);
            entries.remove(entry);
        }
    }

    @Override
    public void remove(List<Path> entries) {

        for(Path entry: entries) {
            remove(entry);
        }
    }

    @Override
    public void removeAll() {

        for(Path entry: entries) {
            remove(entry);
        }
    }

    @Override
    public List<Path> getEntries() {

        return entries;
    }

    private void monitor(Path entry) {

        Path dir = entry.getParent();
        if(monitors.containsKey(dir)) {
            return;
        }

        try {
            DirectoryMonitor dm = new DirectoryMonitorImpl(dir, false, new DirectoryMonitorEventListener() {

                @Override
                public void action(Path dir, Path cause, Kind<Path> event) {

                    if(entries.contains(cause)) {
                        for(FileMonitorEventListener listener: listeners) {
                            listener.action(cause, event);
                        }
                    }
                }
            });
            dm.start();
            monitors.put(dir, dm);
        }
        catch(IOException e) {
            logger.error("cannot monitor directory", e);
        }
    }

    private void unmonitor(Path entry) {

        Path dir = entry.getParent();
        if(!monitors.containsKey(dir)) {
            return;
        }

        DirectoryMonitor dm = monitors.get(dir);
        dm.stop();
        monitors.remove(dir);
    }

}
