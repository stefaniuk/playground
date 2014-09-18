package io.codeworks.file.explorer.commons.bin;

import io.codeworks.file.explorer.commons.exception.FileExplorerException;

import java.nio.file.DirectoryStream;
import java.nio.file.FileSystem;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import com.google.common.collect.Lists;

public class LocalCurrentDirectory {

    private FileSystem fs;

    private Path path;

    public LocalCurrentDirectory(FileSystem fileSystem) {

        this.fs = fileSystem;
        this.path = fileSystem.getPath(fileSystem.getSeparator());
    }

    public List<Path> getEntries() {

        try(DirectoryStream<Path> paths = Files.newDirectoryStream(path)) {
            return Lists.newArrayList(paths);
        }
        catch(Exception e) {
            throw new FileExplorerException("Unable to retrieve entries from current directory", e);
        }
    }

    public void changeCurrentDirectory(Path path) {

        this.path = path;
    }

    public void changeCurrentDirectory(String path) {

        this.path = fs.getPath(path);
    }

    public String getSeparator() {

        return fs.getSeparator();
    }

}
