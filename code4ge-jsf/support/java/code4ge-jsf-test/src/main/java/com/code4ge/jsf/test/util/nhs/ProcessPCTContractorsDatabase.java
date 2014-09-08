package com.code4ge.jsf.test.util.nhs;

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

import com.code4ge.jsf.test.model.nhs.PCTContractors;
import com.code4ge.jsf.test.model.nhs.PCTContractorsDao;
import com.code4ge.jsf.test.util.earthquake.ProcessEarthquakeDatabase;

public class ProcessPCTContractorsDatabase {

    /** PCT contractors data access object. */
    @Autowired
    private PCTContractorsDao pctContractorsDao;

    /** Session object injected by the container. */
    @Autowired
    private HttpSession session;

    public void createDatabase() throws SqlJetException, IOException {

        File file = new File(session.getServletContext().getRealPath("/WEB-INF/classes") + "/pctcontractors.db");
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
            db.createTable("CREATE TABLE pctcontractors (" +
                "pctCode TEXT NOT NULL," +
                "pctName TEXT NOT NULL," +
                "countGp INTEGER NOT NULL," +
                "duplicateGp INTEGER NOT NULL," +
                "countOptician INTEGER NOT NULL," +
                "duplicateOptician INTEGER NOT NULL," +
                "countDentist INTEGER NOT NULL," +
                "duplicateDentist INTEGER NOT NULL," +
                "percentageDulicate REAL NOT NULL" +
                ")");
            db.createIndex("CREATE INDEX pctCode_index ON pctcontractors (pctCode)");
            db.createIndex("CREATE INDEX pctName_index ON pctcontractors (pctName)");
            db.createIndex("CREATE INDEX percentageDulicate_index ON pctcontractors (percentageDulicate)");
        }
        finally {
            db.commit();
        }

        db.beginTransaction(SqlJetTransactionMode.WRITE);
        try {
            ISqlJetTable table = db.getTable("pctcontractors");

            InputStream is = ProcessEarthquakeDatabase.class.getClassLoader().getResourceAsStream(
                "pct_contractors_database");
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
                    PCTContractors pctc = new PCTContractors(line);
                    table.insert(
                        pctc.getPctCode(),
                        pctc.getPctName(),
                        pctc.getCountGp(),
                        pctc.getDuplicateGp(),
                        pctc.getCountOptician(),
                        pctc.getDuplicateOptician(),
                        pctc.getCountDentist(),
                        pctc.getDuplicateDentist(),
                        pctc.getPercentageDuplicate());
                }
            }
            dis.close();

        }
        finally {
            db.commit();
        }
        db.close();

        List<PCTContractors> list = pctContractorsDao.findAll();
        System.out.println("Number of PCT contractors records: " + list.size());

    }

}
