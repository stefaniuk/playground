package io.codeworks.file.monitor.core;

import java.nio.file.Path;
import java.nio.file.WatchEvent.Kind;
import java.util.EventListener;

public interface FileMonitorEventListener extends EventListener {

    public void action(Path entry, Kind<Path> event);

}
