package io.codeworks.file.explorer.commons.bin;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;

import org.joda.time.DateTime;

public class FileSystemEntry {

    private Path entry;

    private BasicFileAttributes attributes;

    public FileSystemEntry(Path path) {

        entry = path;
    }

    public boolean isFile() {

        return attributes.isRegularFile();
    }

    public boolean isDirectory() {

        return attributes.isDirectory();
    }

    public String getPath() {

        return entry.getParent().toFile().getAbsolutePath();
    }

    public String getName() {

        return entry.getFileName().toFile().getName();
    }

    public long getSize() {

        return getAttributes().size();
    }

    public DateTime getDateCreated() {

        return new DateTime(getAttributes().creationTime().toMillis());
    }

    public DateTime getDateModified() {

        return new DateTime(getAttributes().lastModifiedTime().toMillis());
    }

    public DateTime getDateAccessed() {

        return new DateTime(getAttributes().lastAccessTime().toMillis());
    }

    private BasicFileAttributes getAttributes() {

        if(attributes == null) {
            try {
                attributes = Files.readAttributes(entry, BasicFileAttributes.class);
            }
            catch(IOException e) {
                e.printStackTrace(System.err);
            }
        }

        return attributes;
    }

    @Override
    public String toString() {

        StringBuilder sb = new StringBuilder(this.getClass() + "@" + Integer.toHexString(this.hashCode()) + " ");

        try {
            sb.append(getPath());
            sb.append(entry.getFileSystem().getSeparator());
            sb.append(getName() + " ");
            sb.append((isFile() ? "file" : "directory") + " ");
            sb.append(getSize());
        }
        catch(Exception e) {

        }

        return sb.toString();
    }

}
