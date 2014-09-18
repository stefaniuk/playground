package io.codeworks.file.explorer.commons.operation;

import io.codeworks.file.explorer.commons.domain.Entry;
import io.codeworks.file.explorer.commons.domain.Session;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Action {

    private Session session;

    public Action(Session session) {

        this.session = session;
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

}
