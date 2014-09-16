package io.codeworks.file.monitor.core;

import java.nio.file.Path;
import java.util.List;

public interface FileMonitor extends Monitor {

    public void addListener(FileMonitorEventListener listener);

    public void removeListener(FileMonitorEventListener listener);

    public void add(Path entry);

    public void add(List<Path> entries);

    public void remove(Path entry);

    public void remove(List<Path> entries);

    public void removeAll();

    public List<Path> getEntries();

}
