package io.codeworks.spring.samples.security.auth.dao;

import io.codeworks.spring.common.model.User;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("userDao")
public class UserDao {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    private SessionFactory sessionFactory;

    @SuppressWarnings("unchecked")
    public User fetchByUsername(String username) {

        logger.debug("fetch user by username " + username);

        Session session = sessionFactory.openSession();
        try {
            List<User> list = (List<User>) session.createCriteria(User.class)
                .add(Restrictions.eq("username", username))
                .list();

            if(list.size() == 1) {
                logger.debug("user fetched by username " + list.get(0));
                return list.get(0);
            }
        }
        finally {
            session.close();
        }

        return null;
    }

    @SuppressWarnings("unchecked")
    public List<User> fetchAll() {

        logger.debug("fetch all users");

        List<User> list;

        Session session = sessionFactory.openSession();
        try {
            Query query = session.createQuery("from " + User.class.getName());
            list = (List<User>) query.list();

            logger.debug("all " + list.size() + " users fetched");
        }
        finally {
            session.close();
        }

        return list;
    }

    public User update(User user) {

        logger.debug("update user " + user);

        Session session = sessionFactory.openSession();
        try {
            if(user.getId() >= 0) {
                session.update(user);

                logger.debug("user updated");
            }
            else {
                logger.debug("user not updated");
            }
        }
        catch(Exception e) {
            throw e;
        }
        finally {
            session.close();
        }

        return user;
    }

}
