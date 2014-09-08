package com.code4ge.jsf.test.store.earthquake;

import java.util.List;

import com.code4ge.jsf.mvc.model.Store;
import com.code4ge.jsf.mvc.store.AbstractChartStore;
import com.code4ge.jsf.mvc.store.QueryStore;
import com.code4ge.jsf.test.model.earthquake.Earthquake;
import com.code4ge.jsf.test.model.earthquake.EarthquakeDao;
import com.code4ge.json.service.JsonService;

public class EarthquakeStore extends AbstractChartStore<Earthquake, EarthquakeDao> {

    @Override
    @JsonService
    public Store<Earthquake> select(QueryStore queryStore) {

        List<Earthquake> items = dao.findAll();

        return new Store<Earthquake>("rowid", "rowid", "country", items);
    }

}
