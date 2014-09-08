package com.code4ge.jsf.test.store.nhs;

import java.util.List;

import com.code4ge.jsf.mvc.model.Store;
import com.code4ge.jsf.mvc.store.AbstractChartStore;
import com.code4ge.jsf.mvc.store.QueryStore;
import com.code4ge.jsf.test.model.nhs.PCTContractors;
import com.code4ge.jsf.test.model.nhs.PCTContractorsDao;
import com.code4ge.json.service.JsonService;

public class PCTContractorsStore extends AbstractChartStore<PCTContractors, PCTContractorsDao> {

    @Override
    @JsonService
    public Store<PCTContractors> select(QueryStore queryStore) {

        List<PCTContractors> items = dao.findAll();

        return new Store<PCTContractors>("pctCode", "pctCode", "pctName", items);
    }

}
