package com.code4ge.jsf.test.model.earthquake;

import java.util.Map;

import com.code4ge.jsf.mvc.model.AbstractModel;
import com.code4ge.jsf.mvc.model.ModelColumn;
import com.code4ge.jsf.mvc.model.ModelTable;

@ModelTable(name = "earthquakes")
public class Earthquake extends AbstractModel {

    @ModelColumn(name = "rowid")
    private Integer id;

    @ModelColumn(name = "year")
    private Integer year;

    @ModelColumn(name = "month")
    private Integer month;

    @ModelColumn(name = "day")
    private Integer day;

    @ModelColumn(name = "hour")
    private Integer hour;

    @ModelColumn(name = "minute")
    private Integer minute;

    @ModelColumn(name = "country")
    private String country;

    @ModelColumn(name = "latitude")
    private Double latitude;

    @ModelColumn(name = "longitude")
    private Double longitude;

    @ModelColumn(name = "magnitude")
    private Double magnitude;

    public Earthquake(Integer id, Integer year, Integer month, Integer day, Integer hour, Integer minute,
            String country, Double latitude, Double longitude, Double magnitude) {

        this.id = id;
        this.year = year;
        this.month = month;
        this.day = day;
        this.hour = hour;
        this.minute = minute;
        this.country = country;
        this.latitude = latitude;
        this.longitude = longitude;
        this.magnitude = magnitude;
    }

    public Earthquake(String line) {

        String[] data = line.split("\t");

        year = Integer.parseInt(data[2].trim());
        month = data[3].trim().equals("") ? 0 : Integer.parseInt(data[3]);
        day = data[4].trim().equals("") ? 0 : Integer.parseInt(data[4]);
        hour = data[5].trim().equals("") ? 0 : Integer.parseInt(data[5]);
        minute = data[6].trim().equals("") ? 0 : Integer.parseInt(data[6]);
        country = data[16].trim();
        latitude = data[19].trim().equals("") ? 0 : Double.parseDouble(data[19]);
        longitude = data[20].trim().equals("") ? 0 : Double.parseDouble(data[20]);
        magnitude = data[9].trim().equals("") ? 0 : Double.parseDouble(data[9]);
    }

    public Earthquake(Map<String, Object> row) {

        id = (Integer) row.get(getColumnName(this.getClass(), "id"));
        year = (Integer) row.get(getColumnName(this.getClass(), "year"));
        month = (Integer) row.get(getColumnName(this.getClass(), "month"));
        day = (Integer) row.get(getColumnName(this.getClass(), "day"));
        hour = (Integer) row.get(getColumnName(this.getClass(), "hour"));
        minute = (Integer) row.get(getColumnName(this.getClass(), "minute"));
        country = (String) row.get(getColumnName(this.getClass(), "country"));
        latitude = (Double) row.get(getColumnName(this.getClass(), "latitude"));
        longitude = (Double) row.get(getColumnName(this.getClass(), "longitude"));
        magnitude = (Double) row.get(getColumnName(this.getClass(), "magnitude"));
    }

    @Override
    public Integer getId() {

        return id;
    }

    public Integer getYear() {

        return year;
    }

    public void setYear(Integer year) {

        this.year = year;
    }

    public Integer getMonth() {

        return month;
    }

    public void setMonth(Integer month) {

        this.month = month;
    }

    public Integer getDay() {

        return day;
    }

    public void setDay(Integer day) {

        this.day = day;
    }

    public Integer getHour() {

        return hour;
    }

    public void setHour(Integer hour) {

        this.hour = hour;
    }

    public Integer getMinute() {

        return minute;
    }

    public void setMinute(Integer minute) {

        this.minute = minute;
    }

    public String getCountry() {

        return country;
    }

    public void setCountry(String country) {

        this.country = country;
    }

    public Double getLatitude() {

        return latitude;
    }

    public void setLatitude(Double latitude) {

        this.latitude = latitude;
    }

    public Double getLongitude() {

        return longitude;
    }

    public void setLongitude(Double longitude) {

        this.longitude = longitude;
    }

    public Double getMagnitude() {

        return magnitude;
    }

    public void setMagnitude(Double magnitude) {

        this.magnitude = magnitude;
    }

}
