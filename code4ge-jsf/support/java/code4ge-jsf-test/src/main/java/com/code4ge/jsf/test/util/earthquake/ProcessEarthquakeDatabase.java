package com.code4ge.jsf.test.util.earthquake;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.tmatesoft.sqljet.core.SqlJetException;
import org.tmatesoft.sqljet.core.SqlJetTransactionMode;
import org.tmatesoft.sqljet.core.table.ISqlJetTable;
import org.tmatesoft.sqljet.core.table.SqlJetDb;

import com.code4ge.jsf.test.model.earthquake.Earthquake;
import com.code4ge.jsf.test.model.earthquake.EarthquakeDao;

public class ProcessEarthquakeDatabase {

    /** Earthquake data access object. */
    @Autowired
    private EarthquakeDao earthquakeDao;

    /** Session object injected by the container. */
    @Autowired
    private HttpSession session;

    public void createDatabase() throws SqlJetException, IOException {

        File file = new File(session.getServletContext().getRealPath("/WEB-INF/classes") + "/earthquakes.db");
        if(file.exists()) {
            file.delete();
            return;
        }

        SqlJetDb db = SqlJetDb.open(file, true);
        // db.getOptions().setAutovacuum(true);
        db.beginTransaction(SqlJetTransactionMode.WRITE);
        try {
            db.getOptions().setUserVersion(1);
        }
        finally {
            db.commit();
        }

        db.beginTransaction(SqlJetTransactionMode.WRITE);
        try {
            db.createTable("CREATE TABLE earthquakes (" +
                "year INTEGER NOT NULL," +
                "month INTEGER NOT NULL," +
                "day INTEGER NOT NULL," +
                "hour INTEGER NOT NULL," +
                "minute INTEGER NOT NULL," +
                "country TEXT NULL," +
                "latitude REAL NOT NULL," +
                "longitude REAL NOT NULL," +
                "magnitude REAL NOT NULL" +
                ")");
            db.createIndex("CREATE INDEX time_index ON earthquakes (year, month, day, hour, minute)");
            db.createIndex("CREATE INDEX place_index ON earthquakes (country)");
            db.createIndex("CREATE INDEX location_index ON earthquakes (latitude, longitude)");
            db.createIndex("CREATE INDEX magnitude_index ON earthquakes (magnitude)");
        }
        finally {
            db.commit();
        }

        db.beginTransaction(SqlJetTransactionMode.WRITE);
        try {
            ISqlJetTable table = db.getTable("earthquakes");

            InputStream is = ProcessEarthquakeDatabase.class.getClassLoader().getResourceAsStream(
                "the_significant_earthquake_database");
            DataInputStream dis = new DataInputStream(is);
            BufferedReader br = new BufferedReader(new InputStreamReader(dis));
            String line;
            int i = 0;
            while((line = br.readLine()) != null) {
                i++;
                if(i <= 1) {
                    continue;
                }
                else {
                    Earthquake eq = new Earthquake(line);
                    table.insert(
                        eq.getYear(),
                        eq.getMonth(),
                        eq.getDay(),
                        eq.getHour(),
                        eq.getMinute(),
                        eq.getCountry(),
                        eq.getLatitude(),
                        eq.getLongitude(),
                        eq.getMagnitude());
                }
            }
            dis.close();

        }
        finally {
            db.commit();
        }
        db.close();

        List<Earthquake> list = earthquakeDao.findAll();
        System.out.println("Number of earthquake records: " + list.size());

    }

}
