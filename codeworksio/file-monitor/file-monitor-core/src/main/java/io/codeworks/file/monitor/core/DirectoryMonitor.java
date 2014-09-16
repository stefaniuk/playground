package io.codeworks.file.monitor.core;

import java.nio.file.Path;

public interface DirectoryMonitor extends Monitor {

    public void setDir(Path dir);

    public void setRecursive(boolean recursive);

    public void setListener(DirectoryMonitorEventListener listener);

}
