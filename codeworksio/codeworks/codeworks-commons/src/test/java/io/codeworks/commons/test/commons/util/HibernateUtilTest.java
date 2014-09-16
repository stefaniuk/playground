package io.codeworks.commons.test.commons.util;

import io.codeworks.commons.commons.util.HibernateUtil;
import io.codeworks.commons.test.Config;
import io.codeworks.commons.test.application.User;
import io.codeworks.commons.test.application.UserRepository;
import io.codeworks.commons.test.application.Util;

import java.util.Arrays;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = { Config.class })
public class HibernateUtilTest {

    private static final long NUMBER_OF_ITEMS = 10;

    @Autowired
    private UserRepository userRepository;

    @Before
    public void setUp() {

        for(int i = 0; i < NUMBER_OF_ITEMS; i++) {
            Util.createUser(
                userRepository,
                "User " + i,
                "password" + i,
                i < NUMBER_OF_ITEMS / 2 ? "ROLE_USER" : "ROLE_USER,ROLE_ADMIN");
        }
    }

    @After
    public void tearDown() {

        userRepository.deleteAll();
    }

    @Test
    public void testConvertModelToCriteriaStringExactMatch() {

        User user = Util.getUser("User 3", null, null);
        DetachedCriteria criteria = HibernateUtil.convertModelToCriteria(user);

        List<User> users = userRepository.find(criteria);

        Assert.isTrue(users.size() == 1);
    }

    @Test
    public void testConvertModelToCriteriaStringLikeMatch() {

        User user = Util.getUser("User" + HibernateUtil.WILDCARD, null, null);
        DetachedCriteria criteria = HibernateUtil.convertModelToCriteria(user);

        List<User> users = userRepository.find(criteria);

        Assert.isTrue(users.size() == 10);
    }

    @Test
    public void testConvertModelToCriteriaNonStringMatch() {

        User user = Util.createUser(userRepository, "user", "password", "role");
        User u = new User();
        u.setId(user.getId());
        DetachedCriteria criteria = HibernateUtil.convertModelToCriteria(u);

        List<User> users = userRepository.find(criteria);

        System.out.println(Arrays.toString(users.toArray()));
        Assert.isTrue(users.size() == 1);
    }

}
