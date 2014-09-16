package io.codeworks.commons.data.repository;

import io.codeworks.commons.commons.util.ObjectUtil;
import io.codeworks.commons.data.model.Model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.ObjectNotFoundException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.GenericTypeResolver;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;

/**
 * This class provides CRUD operations on a domain model. It supports
 * transactions and throws an exception if operation is not successful.
 * 
 * @param <T> Concrete domain model implementation
 * @author Daniel Stefaniuk
 */
public class HibernateRepository<T extends Model> implements Repository<T, DetachedCriteria> {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired(required = false)
    private SessionFactory sessionFactory;

    private Session session;

    private Class<T> clazz;

    private String clazzName;

    @SuppressWarnings("unchecked")
    public HibernateRepository() {

        clazz = (Class<T>) GenericTypeResolver.resolveTypeArgument(getClass(), HibernateRepository.class);
        clazzName = clazz.getName();
    }

    public SessionFactory getSessionFactory() {

        return sessionFactory;
    }

    /**
     * Set Hibernate session factory.
     * 
     * @param sessionFactory
     */
    public void setSessionFactory(SessionFactory sessionFactory) {

        this.sessionFactory = sessionFactory;
    }

    public Session getSession() {

        return session;
    }

    /**
     * Set Hibernate session to be managed externally. Session factory will be
     * ignored.
     * 
     * @param session
     */
    public void setSession(Session session) {

        this.session = session;
    }

    public Class<T> getClazz() {

        return clazz;
    }

    public String getClazzName() {

        return clazzName;
    }

    @Override
    @SuppressWarnings("unchecked")
    public T find(Long id) {

        logger.debug("find by id " + id);

        T item = null;

        Session session = openSession();
        try {
            item = (T) session.get(clazz, id);
            logger.debug(item != null ? "found " : "not found");
        }
        finally {
            closeSession(session);
        }

        return item;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> find(List<Long> ids) {

        logger.debug("find by ids " + tostr(ids));

        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            Criteria criteria = session.createCriteria(clazz);
            criteria.add(Restrictions.in("id", ids));
            list = (List<T>) criteria.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> find(List<Long> ids, Sort sort) {

        logger.debug("find by ids " + tostr(ids) + ", sort " + sort);

        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            Criteria criteria = session.createCriteria(clazz);
            criteria.add(Restrictions.in("id", ids));
            criteria = makeResultSortable(criteria, sort);
            list = (List<T>) criteria.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public ResultPage<T> find(List<Long> ids, RequestPage page) {

        logger.debug("find by ids " + tostr(ids) + ", " + page);

        long total = 0;
        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            DetachedCriteria criteria = DetachedCriteria.forClass(clazz);
            criteria.add(Restrictions.in("id", ids));

            total = count(criteria);
            Criteria crit = criteria.getExecutableCriteria(session);
            crit = makeResultPageable(crit, page);
            list = (List<T>) crit.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return new ResultPage<T>(list, total, page);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> find(DetachedCriteria criteria) {

        logger.debug("find by criteria " + criteria);

        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            Criteria crit = criteria.getExecutableCriteria(session);
            list = (List<T>) crit.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> find(DetachedCriteria criteria, Sort sort) {

        logger.debug("find by criteria " + criteria + ", sort " + sort);

        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            Criteria crit = criteria.getExecutableCriteria(session);
            crit = makeResultSortable(crit, sort);
            list = (List<T>) crit.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public ResultPage<T> find(DetachedCriteria criteria, RequestPage page) {

        logger.debug("find by criteria " + criteria + ", " + page);

        long total = 0;
        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            total = count(criteria);
            Criteria crit = criteria.getExecutableCriteria(session);
            crit = makeResultPageable(crit, page);
            list = (List<T>) crit.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return new ResultPage<T>(list, total, page);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> findAll() {

        logger.debug("find all");

        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            Query query = session.createQuery("from " + clazzName);
            list = (List<T>) query.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> findAll(Sort sort) {

        logger.debug("find all, sort " + sort);

        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            Criteria criteria = session.createCriteria(clazz);
            criteria = makeResultSortable(criteria, sort);
            list = (List<T>) criteria.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public ResultPage<T> findAll(RequestPage page) {

        logger.debug("find all, " + page);

        long total = 0;
        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            total = countAll();
            Criteria criteria = session.createCriteria(clazz);
            criteria = makeResultPageable(criteria, page);
            list = (List<T>) criteria.list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return new ResultPage<T>(list, total, page);
    }

    @SuppressWarnings("unchecked")
    public T findUniqueByField(String name, Object value) {

        logger.debug("find by field name " + name);

        T item = null;

        Session session = openSession();
        try {
            item = (T) session.createCriteria(clazz)
                .add(Restrictions.eq(name, value))
                .uniqueResult();
            logger.debug("found " + item);
        }
        finally {
            closeSession(session);
        }

        return item;
    }

    @SuppressWarnings("unchecked")
    public List<T> findByField(String name, Object value) {

        logger.debug("find by field name " + name);

        List<T> list = new ArrayList<>();

        Session session = openSession();
        try {
            list = (List<T>) session.createCriteria(clazz)
                .add(Restrictions.eq(name, value))
                .list();
            logger.debug("found " + list.size() + " " + tostr(list));
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    public T save(T model) {

        logger.debug("save " + model);

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            beginTransaction(tx);
            session.save(model);
            commitTransaction(tx);
            logger.debug("saved with id " + model.getId());
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }

        return model;
    }

    @Override
    public List<T> save(List<T> models) {

        logger.debug("save " + tostr(models));

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            beginTransaction(tx);
            for(T model: models) {
                session.save(model);
            }
            commitTransaction(tx);
            List<Long> ids = new ArrayList<>();
            for(T model: models) {
                ids.add(model.getId());
            }
            logger.debug("saved with ids " + tostr(ids));
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }

        return models;
    }

    @Override
    public T update(T model) {

        logger.debug("update " + model);

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            beginTransaction(tx);
            session.update(model);
            commitTransaction(tx);
            logger.debug("updated");
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }

        return model;
    }

    @Override
    public List<T> update(List<T> models) {

        logger.debug("update " + tostr(models));

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            beginTransaction(tx);
            for(T model: models) {
                session.update(model);
            }
            commitTransaction(tx);
            logger.debug("updated");
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }

        return models;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<T> update(DetachedCriteria criteria, T values) {

        logger.debug("update by criteria " + criteria + ", values " + values);

        List<T> list = new ArrayList<>();

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            beginTransaction(tx);
            Criteria crit = criteria.getExecutableCriteria(session);
            list = (List<T>) crit.list();
            for(T item: list) {
                ObjectUtil.copyBeanProperties(values, item);
                session.update(item);
            }
            commitTransaction(tx);
            logger.debug("updated " + list.size());
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }

        return list;
    }

    @Override
    @SuppressWarnings("unchecked")
    public void delete(Long id) {

        logger.debug("delete by id " + id);

        Session session = openSession();
        T model = (T) session.get(clazz, id);
        if(model == null) {
            throw new ObjectNotFoundException(id, clazzName);
        }

        Transaction tx = getTransaction(session);
        try {
            beginTransaction(tx);
            session.delete(model);
            commitTransaction(tx);
            logger.debug("deleted");
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public void delete(List<Long> ids) {

        logger.debug("delete by ids " + tostr(ids));

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            beginTransaction(tx);
            int count = 0;
            for(Long id: ids) {
                T model = (T) session.get(clazz, id);
                if(model == null) {
                    throw new ObjectNotFoundException(id, clazzName);
                }
                session.delete(model);
                count++;
            }
            commitTransaction(tx);
            logger.debug("deleted " + count);
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public void delete(DetachedCriteria criteria) {

        logger.debug("delete by criteria " + criteria);

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            Criteria crit = criteria.getExecutableCriteria(session);
            List<T> list = (List<T>) crit.list();

            beginTransaction(tx);
            int count = 0;
            for(T item: list) {
                session.delete(item);
                count++;
            }
            commitTransaction(tx);
            logger.debug("deleted " + count);
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public void deleteAll() {

        logger.debug("delete all");

        Session session = openSession();
        Transaction tx = getTransaction(session);
        try {
            Query query = session.createQuery("from " + clazzName);
            List<T> list = (List<T>) query.list();

            beginTransaction(tx);
            int count = 0;
            for(T item: list) {
                session.delete(item);
                count++;
            }
            commitTransaction(tx);
            logger.debug("deleted " + count);
        }
        catch(HibernateException e) {
            rollbackTransaction(tx);
            throw e;
        }
        finally {
            closeSession(session);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public boolean exists(Long id) {

        logger.debug("check if exists by id " + id);

        T model = null;

        Session session = openSession();
        try {
            model = (T) session.get(clazz, id);
            logger.debug(model != null ? "exists" : "does not exist");
        }
        finally {
            closeSession(session);
        }

        return model != null;
    }

    @Override
    public long count(DetachedCriteria criteria) {

        criteria = ObjectUtil.clone(criteria);

        Session session = openSession();
        Criteria crit = criteria.getExecutableCriteria(session);
        crit.setProjection(Projections.rowCount());
        long count = (long) crit.uniqueResult();
        closeSession(session);

        return count;
    }

    @Override
    public long countAll() {

        Session session = openSession();
        Criteria criteria = session.createCriteria(clazzName);
        criteria.setProjection(Projections.rowCount());
        long count = (long) criteria.uniqueResult();
        closeSession(session);

        return count;
    }

    private Criteria makeResultPageable(Criteria criteria, RequestPage page) {

        criteria = makeResultSortable(criteria, page.getSort());

        int pn = page.getPageNumber();
        int ps = page.getPageSize();

        criteria.setFirstResult(pn * ps);
        criteria.setMaxResults(ps);

        return criteria;
    }

    private Criteria makeResultSortable(Criteria criteria, Sort sort) {

        if(sort != null) {
            for(Iterator<Sort.Order> it = sort.iterator(); it.hasNext();) {
                Sort.Order order = it.next();
                if(order.getDirection() == Direction.ASC) {
                    criteria.addOrder(Order.asc(order.getProperty()));
                }
                else {
                    criteria.addOrder(Order.desc(order.getProperty()));
                }
            }
        }

        return criteria;
    }

    /**
     * Return Hibernate session. A new session object will be created if it
     * hasn't been provided that will be managed internally.
     * 
     * @return
     */
    private Session openSession() {

        if(isInternalSession()) {
            return sessionFactory.openSession();
        }
        else {
            return this.session;
        }
    }

    /**
     * Close session only if the session is managed internally.
     * 
     * @param session
     */
    private void closeSession(Session session) {

        if(isInternalSession()) {
            session.close();
        }
    }

    /**
     * Checks if session is managed internally. Session is managed internally
     * only if it hasn't been provided.
     * 
     * @return
     */
    private boolean isInternalSession() {

        return this.session == null;
    }

    /**
     * If session is managed internally returns transaction object tied to the
     * current session.
     * 
     * @param session
     * @return
     */
    private Transaction getTransaction(Session session) {

        if(isInternalSession()) {
            return session.getTransaction();
        }
        else {
            return null;
        }
    }

    /**
     * If session is managed internally begin transaction.
     * 
     * @param transaction
     */
    private void beginTransaction(Transaction transaction) {

        if(isInternalSession()) {
            transaction.begin();
        }
    }

    /**
     * If session is managed internally commit transaction.
     * 
     * @param transaction
     */
    private void commitTransaction(Transaction transaction) {

        if(isInternalSession()) {
            transaction.commit();
        }
    }

    /**
     * If session is managed internally rollback transaction.
     * 
     * @param transaction
     */
    private void rollbackTransaction(Transaction transaction) {

        if(isInternalSession()) {
            transaction.rollback();
        }
    }

    private String tostr(List<?> list) {

        return Arrays.toString(list.toArray());
    }

}
