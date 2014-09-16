package io.codeworks.file.monitor.core.test;

import io.codeworks.file.monitor.core.FileMonitor;
import io.codeworks.file.monitor.core.FileMonitorEventListener;
import io.codeworks.file.monitor.core.FileMonitorImpl;
import io.codeworks.file.monitor.core.test.impl.FileMonitorEventListenerImpl;
import io.codeworks.file.monitor.core.test.util.TestUtil;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

public class FileMonitorTest {

    private Path root;

    private FileMonitor monitor;

    private FileMonitorEventListener listener;

    @Before
    public void setUp() throws Exception {

        root = TestUtil.createRootDir();
        listener = Mockito.spy(new FileMonitorEventListenerImpl());
        monitor = new FileMonitorImpl(listener);
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
    public void testSingleFile() throws Exception {

        Path file = Paths.get(root.toString(), "test.file");
        monitor.add(file);

        Files.createFile(file);
        TestUtil.appendToFile(file);
        TestUtil.appendToFile(file);
        TestUtil.appendToFile(file);
        TestUtil.delete(file);

        // check
        Mockito.verify(listener, Mockito.times(1)).action(file, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.atLeast(3)).action(file, StandardWatchEventKinds.ENTRY_MODIFY);
        Mockito.verify(listener, Mockito.times(1)).action(file, StandardWatchEventKinds.ENTRY_DELETE);
    }

    @Test
    public void testMultipleFiles() throws Exception {

        Path file1 = Paths.get(TestUtil.createDirIn(root).toString(), "test1.file");
        monitor.add(file1);
        Path file2 = Paths.get(TestUtil.createDirIn(root).toString(), "test2.file");
        monitor.add(file2);

        Files.createFile(file1);
        Files.createFile(file2);
        TestUtil.appendToFile(file1);
        TestUtil.appendToFile(file2);
        TestUtil.appendToFile(file1);
        TestUtil.appendToFile(file2);
        TestUtil.appendToFile(file1);
        TestUtil.appendToFile(file2);
        TestUtil.delete(file1);
        TestUtil.delete(file2);

        // check
        Mockito.verify(listener, Mockito.times(1)).action(file1, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.atLeast(3)).action(file1, StandardWatchEventKinds.ENTRY_MODIFY);
        Mockito.verify(listener, Mockito.times(1)).action(file1, StandardWatchEventKinds.ENTRY_DELETE);
        Mockito.verify(listener, Mockito.times(1)).action(file2, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.atLeast(3)).action(file2, StandardWatchEventKinds.ENTRY_MODIFY);
        Mockito.verify(listener, Mockito.times(1)).action(file2, StandardWatchEventKinds.ENTRY_DELETE);
    }

    @Test
    public void testNoEvent() throws Exception {

        Path file1 = Paths.get(TestUtil.createDirIn(root).toString(), "test1.file");
        monitor.add(file1);

        Path file2 = Paths.get(root.toString(), "test2.file");
        Files.createFile(file2);
        TestUtil.appendToFile(file2);
        TestUtil.delete(file2);

        // check
        Mockito.verify(listener, Mockito.times(0)).action(file2, StandardWatchEventKinds.ENTRY_CREATE);
        Mockito.verify(listener, Mockito.times(0)).action(file2, StandardWatchEventKinds.ENTRY_MODIFY);
        Mockito.verify(listener, Mockito.times(0)).action(file2, StandardWatchEventKinds.ENTRY_DELETE);
    }

}
