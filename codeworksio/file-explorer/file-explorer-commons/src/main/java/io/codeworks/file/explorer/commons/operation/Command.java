package io.codeworks.file.explorer.commons.operation;

import io.codeworks.file.explorer.commons.domain.Entry;
import io.codeworks.file.explorer.commons.domain.FileSystem;
import io.codeworks.file.explorer.commons.domain.Session;

import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.FileAttribute;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Command {

    private Session session;

    public Command(Session session) {

        this.session = session;
    }

    public void createFile(String name) {

        Entry dir = getCurrentDir();
        FileSystem fs = getCurrentFs();
        Entry entry = fs.getEntry(dir.getFullPath(), name);

        fs.createFile(entry, new FileAttribute<?>[0]);
    }

    public void createDirectory(String name) {

        Entry dir = getCurrentDir();
        FileSystem fs = getCurrentFs();
        Entry entry = fs.getEntry(dir.getFullPath(), name);

        fs.createDirectory(entry, new FileAttribute<?>[0]);
    }

    public void copy() {

        List<Entry> entries = getOperationalEntries();
        Entry dest = getDestinationDir();
        FileSystem fs = getCurrentFs();

        fs.copy(entries, dest, StandardCopyOption.REPLACE_EXISTING);
    }

    public void move() {

        List<Entry> entries = getOperationalEntries();
        Entry dest = getDestinationDir();
        FileSystem fs = getCurrentFs();

        fs.move(entries, dest, StandardCopyOption.REPLACE_EXISTING);
    }

    public void delete() {

        List<Entry> entries = getOperationalEntries();
        FileSystem fs = getCurrentFs();

        fs.delete(entries);
    }

    private List<Entry> getOperationalEntries() {

        List<Entry> list = session.getSelectedEntries();
        if(list == null || list.size() == 0) {
            list = Arrays.asList(session.getCurrentEntry());
        }
        else {
            list = new ArrayList<>();
        }

        return list;
    }

    private Entry getCurrentDir() {

        Entry entry = session.getCurrentDirectory();

        return entry;
    }

    private Entry getDestinationDir() {

        Entry entry = session.getDestinationDirectory();

        return entry;
    }

    private FileSystem getCurrentFs() {

        FileSystem fs = session.getCurrentFileSystem();

        return fs;
    }

}
