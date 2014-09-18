package io.codeworks.file.explorer.commons.domain;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.joda.time.DateTime;

public class Clipboard {

    private static Map<Entry, Map<Long, List<Entry>>> clipboard = new ConcurrentHashMap<Entry, Map<Long, List<Entry>>>();

    public static void add(Entry parent, List<Entry> entries) {

        if(clipboard.containsKey(parent)) {
            Map<Long, List<Entry>> map = clipboard.get(parent);
            map.put(new DateTime().getMillis(), entries);
        }
    }

    public static void remove(Entry parent) {

        clipboard.remove(parent);
    }

    public static void remove(Entry parent, Long timestamp) {

        if(clipboard.containsKey(parent)) {
            Map<Long, List<Entry>> map = clipboard.get(parent);
            map.remove(timestamp);
        }
    }

}
