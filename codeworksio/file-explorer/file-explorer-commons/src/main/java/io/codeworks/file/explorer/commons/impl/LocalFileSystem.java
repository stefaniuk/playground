package io.codeworks.file.explorer.commons.impl;

import io.codeworks.file.explorer.commons.domain.Entry;
import io.codeworks.file.explorer.commons.domain.FileSystem;
import io.codeworks.file.explorer.commons.exception.FileExplorerException;

import java.io.IOException;
import java.net.URI;
import java.nio.file.CopyOption;
import java.nio.file.DirectoryStream;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.OpenOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.FileAttribute;
import java.util.ArrayList;
import java.util.List;

public class LocalFileSystem implements FileSystem {

    private java.nio.file.FileSystem fileSystem;

    public LocalFileSystem() {

        fileSystem = FileSystems.getFileSystem(URI.create("file:/"));
    }

    protected java.nio.file.FileSystem getFileSystem() {

        return fileSystem;
    }

    protected void setFileSystem(java.nio.file.FileSystem fileSystem) {

        this.fileSystem = fileSystem;
    }

    @Override
    public String getSeparator() {

        return fileSystem.getSeparator();
    }

    @Override
    public List<Entry> getRootDirectories() {

        List<Entry> list = new ArrayList<>();

        Iterable<Path> roots = fileSystem.getRootDirectories();
        for(Path path: roots) {
            LocalEntry entry = new LocalEntry(path, this);
            //entry.
            //list.add();
        }

        return list;
    }

    @Override
    public Entry getEntry(String first, String... more) {

        return new LocalEntry(fileSystem.getPath(first, more), this);
    }

    @Override
    public List<Entry> list(Entry directory) {

        List<Entry> list = new ArrayList<>();

        try(DirectoryStream<Path> ds = Files.newDirectoryStream(Paths.get(directory.getFullPath()))) {
            for(Path path: ds) {
                list.add(new LocalEntry(path, this));
            }
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot list entries", e);
        }

        return list;
    }

    @Override
    public Entry createFile(Entry file, FileAttribute<?>... attributes) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Entry createDirectory(Entry directory, FileAttribute<?>... attributes) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Entry createLink(Entry link, Entry target) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Entry copy(Entry entry, Entry directory, CopyOption... options) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Entry copy(List<Entry> entries, Entry directory, CopyOption... options) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Entry move(Entry entry, Entry directory, CopyOption... options) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Entry move(List<Entry> entries, Entry directory, CopyOption... options) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public void delete(Entry entry) {

        // TODO Auto-generated method stub

    }

    @Override
    public void delete(List<Entry> entries) {

        // TODO Auto-generated method stub

    }

    @Override
    public boolean exists(Entry entry, LinkOption... options) {

        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public Entry write(Entry entry, byte[] bytes, OpenOption... options) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public byte[] read(Entry entry) {

        // TODO Auto-generated method stub
        return null;
    }

    public void close() {

        try {
            fileSystem.close();
        }
        catch(UnsupportedOperationException e) {
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot close filesystem", e);
        }
    }

}
