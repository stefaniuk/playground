package com.code4ge.jsf.test.model.nhs;

import java.util.Map;

import com.code4ge.jsf.mvc.model.AbstractModel;
import com.code4ge.jsf.mvc.model.ModelColumn;
import com.code4ge.jsf.mvc.model.ModelTable;

@ModelTable(name = "pctcontractors")
public class PCTContractors extends AbstractModel {

    @ModelColumn(name = "rowid")
    private Integer id;

    @ModelColumn(name = "pctCode")
    private String pctCode;

    @ModelColumn(name = "pctName")
    private String pctName;

    @ModelColumn(name = "countGp")
    private Integer countGp;

    @ModelColumn(name = "duplicateGp")
    private Integer duplicateGp;

    @ModelColumn(name = "countOptician")
    private Integer countOptician;

    @ModelColumn(name = "duplicateOptician")
    private Integer duplicateOptician;

    @ModelColumn(name = "countDentist")
    private Integer countDentist;

    @ModelColumn(name = "duplicateDentist")
    private Integer duplicateDentist;

    @ModelColumn(name = "percentageDulicate")
    private Double percentageDuplicate;

    public PCTContractors(Integer id, String pctCode, String pctName, Integer countGp, Integer duplicateGp,
            Integer countOptician, Integer duplicateOptician, Integer countDentist, Integer duplicateDentist,
            Double percentageDuplicate) {

        this.id = id;
        this.pctCode = pctCode;
        this.pctName = pctName;
        this.countGp = countGp;
        this.duplicateGp = duplicateGp;
        this.countOptician = countOptician;
        this.duplicateOptician = duplicateOptician;
        this.countDentist = countDentist;
        this.duplicateDentist = duplicateDentist;
        this.percentageDuplicate = percentageDuplicate;
    }

    public PCTContractors(String line) {

        String[] data = line.split("\t");

        this.pctCode = data[1].trim();
        this.pctName = data[2].trim();
        this.countGp = Integer.parseInt(data[3].trim());
        this.duplicateGp = Integer.parseInt(data[4].trim());
        this.countOptician = Integer.parseInt(data[5].trim());
        this.duplicateOptician = Integer.parseInt(data[6].trim());
        this.countDentist = Integer.parseInt(data[7].trim());
        this.duplicateDentist = Integer.parseInt(data[8].trim());
        this.percentageDuplicate = Double.parseDouble(data[9].trim());
    }

    public PCTContractors(Map<String, Object> row) {

        this.id = (Integer) row.get(getColumnName(this.getClass(), "id"));
        this.pctCode = (String) row.get(getColumnName(this.getClass(), "pctCode"));
        this.pctName = (String) row.get(getColumnName(this.getClass(), "pctName"));
        this.countGp = (Integer) row.get(getColumnName(this.getClass(), "countGp"));
        this.duplicateGp = (Integer) row.get(getColumnName(this.getClass(), "duplicateGp"));
        this.countOptician = (Integer) row.get(getColumnName(this.getClass(), "countOptician"));
        this.duplicateOptician = (Integer) row.get(getColumnName(this.getClass(), "duplicateOptician"));
        this.countDentist = (Integer) row.get(getColumnName(this.getClass(), "countDentist"));
        this.duplicateDentist = (Integer) row.get(getColumnName(this.getClass(), "duplicateDentist"));
        this.percentageDuplicate = (Double) row.get(getColumnName(this.getClass(), "percentageDulicate"));
    }

    public Integer getId() {

        return id;
    }

    public void setId(Integer id) {

        this.id = id;
    }

    public String getPctCode() {

        return pctCode;
    }

    public void setPctCode(String pctCode) {

        this.pctCode = pctCode;
    }

    public String getPctName() {

        return pctName;
    }

    public void setPctName(String pctName) {

        this.pctName = pctName;
    }

    public Integer getCountGp() {

        return countGp;
    }

    public void setCountGp(Integer countGp) {

        this.countGp = countGp;
    }

    public Integer getDuplicateGp() {

        return duplicateGp;
    }

    public void setDuplicateGp(Integer duplicateGp) {

        this.duplicateGp = duplicateGp;
    }

    public Integer getCountOptician() {

        return countOptician;
    }

    public void setCountOptician(Integer countOptician) {

        this.countOptician = countOptician;
    }

    public Integer getDuplicateOptician() {

        return duplicateOptician;
    }

    public void setDuplicateOptician(Integer duplicateOptician) {

        this.duplicateOptician = duplicateOptician;
    }

    public Integer getCountDentist() {

        return countDentist;
    }

    public void setCountDentist(Integer countDentist) {

        this.countDentist = countDentist;
    }

    public Integer getDuplicateDentist() {

        return duplicateDentist;
    }

    public void setDuplicateDentist(Integer duplicateDentist) {

        this.duplicateDentist = duplicateDentist;
    }

    public Double getPercentageDuplicate() {

        return percentageDuplicate;
    }

    public void setPercentageDuplicate(Double percentageDuplicate) {

        this.percentageDuplicate = percentageDuplicate;
    }

}
