package io.codeworks.file.monitor.core.test;

import io.codeworks.file.monitor.core.DirectoryMonitor;
import io.codeworks.file.monitor.core.DirectoryMonitorEventListener;
import io.codeworks.file.monitor.core.DirectoryMonitorImpl;
import io.codeworks.file.monitor.core.test.impl.DirectoryMonitorEventListenerImpl;
import io.codeworks.file.monitor.core.test.util.TestUtil;

import java.nio.file.Path;
import java.nio.file.StandardWatchEventKinds;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

public class DirectoryMonitorTest {

    private Path root;

    private DirectoryMonitor monitor;

    private DirectoryMonitorEventListener listener;

    @Before
    public void setUp() throws Exception {

        root = TestUtil.createRootDir();
        listener = Mockito.spy(new DirectoryMonitorEventListenerImpl());
        monitor = new DirectoryMonitorImpl(root, false, listener);
        monitor.start();

        Thread.sleep(TestUtil.DELAY);
    }

    @After
    public void tearDown() throws Exception {

        Thread.sleep(TestUtil.DELAY);

        monitor.stop();
        TestUtil.delete(root);
    }

    @Test
    public void testDir() throws Exception {

        Path dir = TestUtil.createDirIn(root);
        TestUtil.delete(dir);

        // check
        Mockito.verify(listener, Mockito.times(1)).action(root, dir, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.times(1)).action(root, dir, StandardWatchEventKinds.ENTRY_DELETE);
    }

    @Test
    public void testFile() throws Exception {

        Path file = TestUtil.createFileIn(root);
        TestUtil.delete(file);

        // check
        Mockito.verify(listener, Mockito.times(1)).action(root, file, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.times(1)).action(root, file, StandardWatchEventKinds.ENTRY_DELETE);
    }

    @Test
    public void testFileAppend() throws Exception {

        Path file = TestUtil.createFileIn(root);
        TestUtil.appendToFile(file);
        TestUtil.delete(file);

        // check
        Mockito.verify(listener, Mockito.times(1)).action(root, file, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.atLeastOnce()).action(root, file, StandardWatchEventKinds.ENTRY_MODIFY);
        Mockito.verify(listener, Mockito.times(1)).action(root, file, StandardWatchEventKinds.ENTRY_DELETE);
    }

    @Test
    public void testRecursive() throws Exception {

        monitor.setRecursive(true);

        Path dir = TestUtil.createDirIn(root);
        Path file = TestUtil.createFileIn(dir);
        TestUtil.appendToFile(file);
        TestUtil.appendToFile(file);
        TestUtil.appendToFile(file);
        TestUtil.delete(file);
        TestUtil.delete(dir);

        // check
        Mockito.verify(listener, Mockito.times(1)).action(root, dir, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.times(1)).action(dir, file, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.atLeast(3)).action(dir, file, StandardWatchEventKinds.ENTRY_MODIFY);
        Mockito.verify(listener, Mockito.times(1)).action(dir, file, StandardWatchEventKinds.ENTRY_DELETE);
        Mockito.verify(listener, Mockito.times(1)).action(root, dir, StandardWatchEventKinds.ENTRY_DELETE);
    }

}
