package io.codeworks.file.explorer.commons.test;

import io.codeworks.file.explorer.commons.bin.LocalCurrentDirectory;

import java.io.IOException;
import java.net.URI;
import java.nio.file.FileStore;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.junit.Test;

public class FileSystemTest {

    public void testLocalFileSystem() throws Exception {

        /*URI uri = URI.create("file:/");
        CurrentDirectory fs = FileSystems.getFileSystem(uri);
        for(Path path: fs.getRootDirectories()) {
            System.out.println(path.toString());
        }
        for(FileStore fileStore: fs.getFileStores()) {

            System.out.println(fileStore.getClass());
        }*/
    }

    public void testZipFileSystem() throws Exception {

        /*URI uri = URI.create("jar:file:/filesystem.zip");
        Map<String, String> env = new HashMap<>();
        env.put("create", "true");
        try(CurrentDirectory fs = FileSystems.newFileSystem(uri, env)) {
            Path file = fs.getPath("/file.txt");
            Set<PosixFilePermission> permissions = PosixFilePermissions.fromString("rw-rw-rw-");
            FileAttribute<Set<PosixFilePermission>> attributes = PosixFilePermissions.asFileAttribute(permissions);
            Files.createFile(file, attributes);
        }*/
    }

    public void test() throws IOException {

        /*CurrentDirectory fs = new CurrentDirectory();
        List<Path> files = fs.getEntries();
        for(Path file: files) {
            System.out.println(file);
        }*/
    }

    @Test
    public void test2() throws IOException {

        /*CurrentDirectory fs = new CurrentDirectory();
        List<Path> drives = fs.getRootEntries();
        for(Path drive: drives) {
            if(drive.startsWith("C:\\")) {
                fs.setCurrentDirectory("C:\\tools");
                List<Path> paths = fs.getEntries();
                for(Path path: paths) {
                    System.out.println(path);
                }
            }
        }*/
    }

}
