package io.codeworks.file.explorer.commons.test.impl;

import io.codeworks.file.explorer.commons.domain.FileSystem;
import io.codeworks.file.explorer.commons.test.Config;

import java.io.IOException;
import java.net.URI;
import java.nio.file.FileStore;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = { Config.class })
public class LocalImplementationTest {

    private FileSystem fileSystem;

    @Before
    public void setUp() {

        //fileSystem = new MockLocalFileSystem();
    }

    @After
    public void tearDown() {

        //fileSystem.close();
    }

    //@Test
    public void testRootDirectories() {

        java.nio.file.FileSystem fs = FileSystems.getFileSystem(URI.create("file:/"));
        for(Path path: fs.getRootDirectories()) {
            System.out.println(path);
        }
    }

    //@Test
    public void testFileStores() {

        java.nio.file.FileSystem fs = FileSystems.getFileSystem(URI.create("file:/"));
        Iterable<FileStore> stores = fs.getFileStores();
        for(FileStore store: stores) {
            String str = store.toString();
            String name = store.name();
            String type = store.type();
            System.out.println(str + ", name=" + name + ", type=" + type);
        }
    }

    @Test
    public void testFileTreeWalker() throws IOException {

        java.nio.file.FileSystem fs = FileSystems.getFileSystem(URI.create("file:/"));
        for(Path path: fs.getRootDirectories()) {
            Files.walkFileTree(path, new FileVisitor<Path>() {

                @Override
                public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {

                    System.out.println(dir.toString());
                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {

                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {

                    System.out.println(file.toString());
                    return FileVisitResult.CONTINUE;
                }

                @Override
                public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {

                    return FileVisitResult.CONTINUE;
                }

            });
        }
    }

}
