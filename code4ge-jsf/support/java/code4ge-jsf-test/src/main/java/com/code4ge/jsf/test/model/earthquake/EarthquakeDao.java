package com.code4ge.jsf.test.model.earthquake;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.code4ge.jsf.mvc.model.AbstractModelDao;
import com.code4ge.jsf.mvc.model.ModelTable;

public class EarthquakeDao extends AbstractModelDao<Earthquake> {

    private String tableName;

    public EarthquakeDao() {

        // get table name
        tableName = Earthquake.class.getAnnotation(ModelTable.class).name();
    }

    @Override
    public Integer create(Earthquake model) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer update(Earthquake model, Earthquake changed) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer remove(Earthquake model) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public List<Earthquake> findAll() {

        List<Earthquake> list = new ArrayList<Earthquake>();

        String sql = String.format("select * from %1$s", tableName);
        List<Map<String, Object>> rows = getJdbcTemplate().queryForList(sql);
        for(Map<String, Object> row: rows) {
            list.add(new Earthquake(row));
        }

        return list;
    }

    @Override
    public Earthquake findById(Integer id) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer findIdByModel(Earthquake model) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer countAll() {

        // TODO Auto-generated method stub
        return null;
    }

    public List<Earthquake> groupByYearFrom(Integer year) {

        List<Earthquake> list = new ArrayList<Earthquake>();
        
        String sql = String.format("select year, count(1) as count, year as name from %1$s where year > " + year + " group by year", tableName);
        List<Map<String, Object>> rows = getJdbcTemplate().queryForList(sql);
        for(Map<String, Object> row: rows) {
            list.add(new Earthquake(row));
        }

        return list;
    }
    
}
