package io.codeworks.file.monitor.core;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchEvent.Kind;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DirectoryMonitorImpl implements DirectoryMonitor {

    private static Logger logger = LoggerFactory.getLogger(DirectoryMonitorImpl.class);

    private Path dir;

    private boolean recursive;

    private DirectoryMonitorEventListener listener;

    private WatchService watcher;

    private Map<WatchKey, Path> entries;

    private Thread thread;

    public DirectoryMonitorImpl() {

    }

    public DirectoryMonitorImpl(Path dir, boolean recursive, DirectoryMonitorEventListener listener) throws IOException {

        this.dir = dir;
        this.recursive = recursive;
        this.listener = listener;
    }

    @Override
    public void setDir(Path dir) {

        this.dir = dir;
    }

    @Override
    public void setRecursive(boolean recursive) {

        this.recursive = recursive;
    }

    @Override
    public void setListener(DirectoryMonitorEventListener listener) {

        this.listener = listener;
    }

    @Override
    public void start() {

        logger.debug("start directory monitor for " + dir);

        if(!Files.isDirectory(dir)) {
            throw new FileMonitorException("Entry must be a directory");
        }

        // prepare
        try {
            watcher = dir.getFileSystem().newWatchService();
            entries = new HashMap<WatchKey, Path>();
            if(recursive) {
                registerAll(dir);
            }
            else {
                register(dir);
            }
        }
        catch(IOException e) {
            throw new FileMonitorException("Cannot create monitor", e);
        }

        thread = new Thread(new Runnable() {

            @Override
            public void run() {

                process();
            }
        });
        thread.start();
    }

    @Override
    public void stop() {

        logger.debug("stop directory monitor for " + dir);

        // clean up
        try {
            watcher.close();
            entries.clear();
        }
        catch(IOException e) {
        }

        thread.interrupt();
    }

    @SuppressWarnings("unchecked")
    public void process() {

        while(!Thread.currentThread().isInterrupted()) {

            // wait for an event
            WatchKey key;
            try {
                key = watcher.take();
            }
            catch(Exception e) {
                return;
            }

            // pool an event
            Path dir = entries.get(key);
            for(WatchEvent<?> event: key.pollEvents()) {

                // get details
                Kind<?> kind = event.kind();
                if(kind == StandardWatchEventKinds.OVERFLOW) {
                    logger.warn("some events may have been lost");
                    continue;
                }
                Path child = dir.resolve(((WatchEvent<Path>) event).context());

                // notify
                listener.action(dir, child, (Kind<Path>) kind);

                // register child if created
                if(kind == StandardWatchEventKinds.ENTRY_CREATE && Files.isDirectory(child)) {
                    try {
                        if(recursive) {
                            registerAll(child);
                        }
                    }
                    catch(IOException e) {
                        logger.error("error while registering child entry", e);
                    }
                }
            }

            if(!key.reset()) {
                entries.remove(key);
            }
        }
    }

    private void registerAll(Path dir) throws IOException {

        Files.walkFileTree(dir, new SimpleFileVisitor<Path>() {

            @Override
            public FileVisitResult preVisitDirectory(Path directory, BasicFileAttributes attrs) throws IOException {

                register(directory);

                return FileVisitResult.CONTINUE;
            }
        });
    }

    private void register(Path dir) throws IOException {

        logger.debug("register " + dir);

        if(Files.isDirectory(dir)) {
            WatchKey key = dir.register(watcher,
                StandardWatchEventKinds.ENTRY_CREATE,
                StandardWatchEventKinds.ENTRY_DELETE,
                StandardWatchEventKinds.ENTRY_MODIFY);
            entries.put(key, dir);
        }
    }

}
