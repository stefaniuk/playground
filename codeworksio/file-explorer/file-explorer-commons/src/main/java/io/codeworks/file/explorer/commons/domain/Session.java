package io.codeworks.file.explorer.commons.domain;

import io.codeworks.file.explorer.commons.exception.FileExplorerException;

import java.util.ArrayList;
import java.util.List;

public class Session {

    private static Clipboard clipboard;

    private List<Location> locations = new ArrayList<>();

    private Location current;

    private Location destination;

    public List<Location> getLocations() {

        return locations;
    }

    public void setLocations(List<Location> locations) {

        this.locations = locations;
    }

    public void addLocation(Location location) {

        locations.add(location);
    }

    public void removeLocation(Location location) {

        locations.remove(location);
    }

    public Location getCurrentLocation() {

        return current;
    }

    public void setCurrentLocation(Location current) {

        if(locations.contains(current)) {
            this.current = current;
        }
        else {
            throw new FileExplorerException("Location does not belong to this session");
        }
    }

    public Location getDestinationLocation() {

        return destination;
    }

    public void setDestinationLocation(Location destination) {

        if(locations.contains(current)) {
            this.destination = destination;
        }
        else {
            throw new FileExplorerException("Location does not belong to this session");
        }
    }

    public void swapLocations() {

        Location tmp = current;
        current = destination;
        destination = tmp;
    }

    public FileSystem getCurrentFileSystem() {

        FileSystem fs = current.getFileSystem();

        return fs;
    }

    public FileSystem getDestinationFileSystem() {

        FileSystem fs = destination.getFileSystem();

        return fs;
    }

    public Entry getCurrentDirectory() {

        Entry entry = current.getDirectory();

        return entry;
    }

    public Entry getDestinationDirectory() {

        Entry entry = destination.getDirectory();

        return entry;
    }

    public List<Entry> getSelectedEntries() {

        List<Entry> entries = current.getSelectedEntries();
        if(entries == null) {
            entries = new ArrayList<>();
        }

        return entries;
    }

    public void setSelectedEntries(List<Entry> entries) {

        current.setSelectedEntries(entries);
    }

    public Entry getCurrentEntry() {

        Entry entry = current.getCurrentEntry();

        return entry;
    }

    public void setCurrentEntry(Entry entry) {

        current.setCurrentEntry(entry);
    }

}
