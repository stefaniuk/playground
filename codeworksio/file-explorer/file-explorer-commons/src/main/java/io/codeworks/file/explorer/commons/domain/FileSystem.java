package io.codeworks.file.explorer.commons.domain;

import java.nio.file.CopyOption;
import java.nio.file.LinkOption;
import java.nio.file.OpenOption;
import java.nio.file.attribute.FileAttribute;
import java.util.List;

public interface FileSystem {

    public String getSeparator();

    public List<Entry> getRootDirectories();

    public Entry getEntry(String first, String... more);

    public List<Entry> list(Entry directory);

    public Entry createFile(Entry file, FileAttribute<?>... attributes);

    public Entry createDirectory(Entry directory, FileAttribute<?>... attributes);

    public Entry createLink(Entry link, Entry target);

    public Entry copy(Entry entry, Entry directory, CopyOption... options);

    public Entry copy(List<Entry> entries, Entry directory, CopyOption... options);

    public Entry move(Entry entry, Entry directory, CopyOption... options);

    public Entry move(List<Entry> entries, Entry directory, CopyOption... options);

    public void delete(Entry entry);

    public void delete(List<Entry> entries);

    public boolean exists(Entry entry, LinkOption... options);

    public Entry write(Entry entry, byte[] bytes, OpenOption... options);

    public byte[] read(Entry entry);

    public void close();

}
