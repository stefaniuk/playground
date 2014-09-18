package io.codeworks.file.explorer.commons.domain;

import java.util.List;

public class Location {

    private FileSystem fileSystem;

    private Entry directory;

    private List<Entry> selectedEntries;

    private Entry currentEntry;

    public Location(FileSystem fileSystem) {

        this.fileSystem = fileSystem;
        this.directory = fileSystem.getEntry(fileSystem.getSeparator());
    }

    public Location(FileSystem fileSystem, Entry directory) {

        this.fileSystem = fileSystem;
        this.directory = directory;
    }

    public FileSystem getFileSystem() {

        return fileSystem;
    }

    public Entry getDirectory() {

        return directory;
    }

    public void changeDirectory(Entry directory) {

        this.directory = directory;
    }

    public Entry getParent() {

        return directory.getParent();
    }

    public List<Entry> getEntries() {

        return fileSystem.list(directory);
    }

    public List<Entry> getSelectedEntries() {

        return selectedEntries;
    }

    public void setSelectedEntries(List<Entry> selectedEntries) {

        this.selectedEntries = selectedEntries;
    }

    public Entry getCurrentEntry() {

        return currentEntry;
    }

    public void setCurrentEntry(Entry currentEntry) {

        this.currentEntry = currentEntry;
    }

}
