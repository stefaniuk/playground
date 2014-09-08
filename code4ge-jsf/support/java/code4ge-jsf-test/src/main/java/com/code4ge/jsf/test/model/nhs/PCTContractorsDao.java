package com.code4ge.jsf.test.model.nhs;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.code4ge.jsf.mvc.model.AbstractModelDao;
import com.code4ge.jsf.mvc.model.ModelTable;

public class PCTContractorsDao extends AbstractModelDao<PCTContractors> {

    private String tableName;

    public PCTContractorsDao() {

        // get table name
        tableName = PCTContractors.class.getAnnotation(ModelTable.class).name();
    }

    @Override
    public Integer create(PCTContractors model) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer update(PCTContractors model, PCTContractors changed) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer remove(PCTContractors model) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public List<PCTContractors> findAll() {

        List<PCTContractors> list = new ArrayList<PCTContractors>();

        String sql = String.format("select * from %1$s", tableName);
        List<Map<String, Object>> rows = getJdbcTemplate().queryForList(sql);
        for(Map<String, Object> row: rows) {
            list.add(new PCTContractors(row));
        }

        return list;
    }

    @Override
    public PCTContractors findById(Integer id) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer findIdByModel(PCTContractors model) {

        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public Integer countAll() {

        // TODO Auto-generated method stub
        return null;
    }

    public List<PCTContractors> orderByPercentageDuplicate(String order) {

        List<PCTContractors> list = new ArrayList<PCTContractors>();

        String sql = String.format("select pctCode as name, * from %1$s order by percentageDulicate " + (order.equals("desc") ? "desc" : "asc"), tableName);
        List<Map<String, Object>> rows = getJdbcTemplate().queryForList(sql);
        for(Map<String, Object> row: rows) {
            list.add(new PCTContractors(row));
        }

        return list;
    }

}
