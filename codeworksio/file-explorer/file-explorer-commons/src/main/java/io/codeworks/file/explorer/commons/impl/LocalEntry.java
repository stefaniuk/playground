package io.codeworks.file.explorer.commons.impl;

import io.codeworks.file.explorer.commons.domain.Entry;
import io.codeworks.file.explorer.commons.domain.EntryType;
import io.codeworks.file.explorer.commons.domain.FileSystem;
import io.codeworks.file.explorer.commons.exception.FileExplorerException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermission;
import java.util.Set;

import org.joda.time.DateTime;

public class LocalEntry implements Entry {

    private FileSystem fileSystem;

    private Path path;

    private EntryType entryType;

    /* package */LocalEntry(FileSystem fileSystem, Path path) {

        this.fileSystem = fileSystem;
        this.path = path;
        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            if(attributes.isRegularFile()) {
                entryType = EntryType.FILE;
            }
            else if(attributes.isDirectory()) {
                entryType = EntryType.DIRECTORY;
            }
            else if(attributes.isDirectory()) {
                entryType = EntryType.LINK;
            }
            else {
                entryType = EntryType.OTHER;
            }
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry type", e);
        }
    }

    /* package */LocalEntry(FileSystem fileSystem, Path path, EntryType type) {

        this.fileSystem = fileSystem;
        this.path = path;
        this.entryType = type;
    }

    /* package */FileSystem getFileSystem() {

        return fileSystem;
    }

    /* package */Path getPath() {

        return path;
    }

    @Override
    public Entry getParent() {

        return new LocalEntry(fileSystem, path.getParent());
    }

    @Override
    public String getFullPath() {

        return path.getParent().toAbsolutePath().toString();
    }

    @Override
    public String getName() {

        return path.getFileName().toString();
    }

    @Override
    public String getMime() {

        try {
            return Files.probeContentType(path);
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry MIME type", e);
        }
    }

    @Override
    public long getSize() {

        try {
            return Files.size(path);
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry size", e);
        }
    }

    @Override
    public DateTime getDateCreated() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            return new DateTime(attributes.creationTime().toMillis());
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry date created", e);
        }
    }

    @Override
    public DateTime getDateModified() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            return new DateTime(attributes.lastModifiedTime().toMillis());
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry date modified", e);
        }
    }

    @Override
    public DateTime getDateAccessed() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            return new DateTime(attributes.lastAccessTime().toMillis());
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry date accessed", e);
        }
    }

    @Override
    public Set<FileAttribute<?>> getAttributes() {

        try {
            Set<PosixFilePermission> permissions = Files.getPosixFilePermissions(path);
            // TODO
            return null;
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry attributes", e);
        }
    }

    @Override
    public boolean isFile() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            return attributes.isRegularFile();
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry type", e);
        }
    }

    @Override
    public boolean isDirectory() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            return attributes.isDirectory();
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry type", e);
        }
    }

    @Override
    public boolean isLink() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            return attributes.isSymbolicLink();
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry type", e);
        }
    }

    @Override
    public boolean isDevice() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            // TODO
            return false;
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry type", e);
        }
    }

    @Override
    public boolean isOther() {

        try {
            BasicFileAttributes attributes = Files.readAttributes(path, BasicFileAttributes.class);
            return attributes.isOther();
        }
        catch(IOException e) {
            throw new FileExplorerException("Cannot get entry type", e);
        }
    }

    @Override
    public String toString() {

        StringBuilder sb = new StringBuilder(this.getClass() + "@" + Integer.toHexString(this.hashCode()) + " ");

        try {
            sb.append(getFullPath());
            sb.append(getFileSystem().getSeparator());
            sb.append(getName() + " ");
            sb.append(getEntryType() + " ");
            sb.append(getSize());
        }
        catch(Exception e) {
        }

        return sb.toString();
    }

}
