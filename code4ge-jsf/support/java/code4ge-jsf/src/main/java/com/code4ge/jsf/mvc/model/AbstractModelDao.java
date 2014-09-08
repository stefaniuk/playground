package com.code4ge.jsf.mvc.model;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcDaoSupport;

/**
 * Spring MVC data access object.
 * 
 * @author Daniel Stefaniuk
 * @param <M> model
 */
public abstract class AbstractModelDao<M> extends NamedParameterJdbcDaoSupport {

    public static final String DATE_FORMAT = "dd MMM yyyy";

    protected final Logger logger = LoggerFactory.getLogger(AbstractModelDao.class);

    /**
     * Saves model in a database.
     * 
     * @param model
     * @return
     */
    public abstract Integer create(M model);

    /**
     * Updates model in a database.
     * 
     * @param model
     * @return
     */
    public Integer update(M model) {

        return update(model, model);
    }

    /**
     * Updates model in a database.
     * 
     * @param model
     * @param changed
     * @return
     */
    public abstract Integer update(M model, M changed);

    /**
     * Removes model from a database.
     * 
     * @param model
     * @return
     */
    public abstract Integer remove(M model);

    /**
     * Returns all models from a database.
     * 
     * @return
     */
    public abstract List<M> findAll();

    /**
     * Returns model by given id.
     * 
     * @param id
     * @return
     */
    public abstract M findById(Integer id);

    /**
     * Returns id by given model.
     * 
     * @param model
     * @return
     */
    public abstract Integer findIdByModel(M model);

    /**
     * Returns number of all models in a database.
     * 
     * @return
     */
    public abstract Integer countAll();

    /**
     * Returns formated date. The default format is "dd MMM yyyy".
     * 
     * @param date
     * @return
     */
    public String formatDate(Date date) {

        return formatDate(date, DATE_FORMAT);
    }

    /**
     * Returns formated date.
     * 
     * @param date
     * @param format
     * @return
     */
    public String formatDate(Date date, String format) {

        if(date == null) {
            return "";
        }

        SimpleDateFormat formatter = new SimpleDateFormat(format);

        return formatter.format(date);
    }

    /**
     * Updates model in database. Only if values are different they are included
     * in the SQL statement.
     * 
     * @param model
     * @param changed
     * @return
     * @throws ModelException
     */
    protected int updateDiffCols(AbstractModel model, AbstractModel changed) {

        /* *** debug begin *** */
        logger.debug("\n *******************************************************************************\n\n");
        logger.debug("\n" + model.toString());
        logger.debug("\n" + changed.toString());
        /* *** debug end *** */

        // compare models
        Map<String, Map<Integer, Object>> cmp = model.modelCompare(changed);
        Set<String> keys = cmp.keySet();

        Class<? extends AbstractModel> c1 = model.getClass();
        Class<? extends AbstractModel> c2 = changed.getClass();

        // get table name to build update statement
        if(c1.getAnnotation(ModelTable.class) == null) {
            throw new ModelException("Cannot get table name");
        }

        int result = 0;

        try {

            String table = c1.getAnnotation(ModelTable.class).name();
            String sql = "update " + table + " set ";

            Object[] values = new Object[keys.size() + 1];
            int i = 0;
            for(String name: keys) {

                // get column name
                String column = c1.getDeclaredField(name).getAnnotation(ModelColumn.class).name();
                sql += column + "=?,";

                // get value
                String getterName = "get" + name.substring(0, 1).toUpperCase() + name.substring(1);
                Method m2 = c2.getMethod(getterName);
                Object value = m2.invoke(changed);
                values[i++] = value;
            }
            if(i > 0) {

                // set where clause
                sql = sql.substring(0, sql.length() - 1);
                sql += " where ID=?";

                values[values.length - 1] = model.getId();

                /* *** debug begin *** */
                logger.debug("\nsql: " + sql);
                logger.debug("\nvalues:");
                for(Object value: values) {
                    logger.debug("\n   " + value);
                }
                logger.debug("\n\n ******************************************************************************* \n");
                /* *** debug end *** */

                // update model
                result = getJdbcTemplate().update(sql, values);

                // log event
                StringBuilder sb = new StringBuilder(sql);
                sb.append(" [");
                for(Object value: values) {
                    sb.append(" ");
                    sb.append(value);
                    sb.append(",");
                }
                sb.deleteCharAt(sb.length() - 1);
                sb.append(" ]");
            }
        }
        catch(SecurityException e) {
            e.printStackTrace();
        }
        catch(NoSuchFieldException e) {
            e.printStackTrace();
        }
        catch(NoSuchMethodException e) {
            e.printStackTrace();
        }
        catch(IllegalArgumentException e) {
            e.printStackTrace();
        }
        catch(IllegalAccessException e) {
            e.printStackTrace();
        }
        catch(InvocationTargetException e) {
            e.printStackTrace();
        }

        return result;
    }

}
