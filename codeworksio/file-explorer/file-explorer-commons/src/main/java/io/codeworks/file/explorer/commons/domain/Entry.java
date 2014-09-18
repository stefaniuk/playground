package io.codeworks.file.explorer.commons.domain;

import java.nio.file.attribute.FileAttribute;
import java.util.Set;

import org.joda.time.DateTime;

public interface Entry {

    //public FileSystem getFileSystem();

    public Entry getParent();

    public String getFullPath();

    public String getName();

    public String getMime();

    public long getSize();

    public DateTime getDateCreated();

    public DateTime getDateModified();

    public DateTime getDateAccessed();

    public Set<FileAttribute<?>> getAttributes(); // TODO: google how to handle this

    public EntryType getEntryType();

    public boolean isFile();

    public boolean isDirectory();

    public boolean isLink();

    public boolean isDevice();

    public boolean isOther();

}
