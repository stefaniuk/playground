package io.codeworks.commons.test.data.repository;

import io.codeworks.commons.data.repository.RequestPage;
import io.codeworks.commons.data.repository.ResultPage;
import io.codeworks.commons.test.Config;
import io.codeworks.commons.test.application.User;
import io.codeworks.commons.test.application.UserRepository;
import io.codeworks.commons.test.application.Util;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.ObjectNotFoundException;
import org.hibernate.TransientObjectException;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Property;
import org.hibernate.criterion.Restrictions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = { Config.class })
public class HibernateRepositoryTest {

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
    public void testGetClazz() {

        Class<User> clazz = userRepository.getClazz();

        Assert.isTrue(clazz == User.class);
    }

    @Test
    public void testGetClassName() {

        String className = userRepository.getClazzName();

        Assert.isTrue(className == User.class.getName());
    }

    @Test
    public void testFindById() {

        User u = Util.createUser(userRepository, "user", "password", null);

        User user = userRepository.find(u.getId());

        Assert.isTrue(user.getId().equals(u.getId()));
    }

    @Test
    public void testFindByIdNonExisting() {

        User user = userRepository.find(0xFFFFL);

        Assert.isNull(user);
    }

    @Test
    public void testFindByIds() {

        User user1 = Util.createUser(userRepository, "user1", "password1", null);
        User user2 = Util.createUser(userRepository, "user2", "password2", null);
        List<Long> ids = new ArrayList<Long>();
        ids.add(user1.getId());
        ids.add(user2.getId());

        List<User> users = userRepository.find(ids);

        Assert.isTrue(users.size() == 2);
        Assert.isTrue(users.get(0).getId().equals(user1.getId()) || users.get(0).getId().equals(user2.getId()));
        Assert.isTrue(users.get(1).getId().equals(user1.getId()) || users.get(1).getId().equals(user2.getId()));
    }

    @Test
    public void testFindByIdsNonExisting() {

        List<Long> ids = new ArrayList<Long>();
        ids.add(0xFFFEL);
        ids.add(0xFFFFL);

        List<User> users = userRepository.find(ids);

        Assert.isTrue(users.size() == 0);
    }

    @Test
    public void testFindByIdsSort() {

        List<User> users = userRepository.findAll();
        List<Long> ids = new ArrayList<Long>();
        for(User user: users) {
            ids.add(user.getId());
        }
        Sort sort = new Sort(Direction.DESC, "username");

        users = userRepository.find(ids, sort);

        Assert.isTrue(users.size() == NUMBER_OF_ITEMS);
        for(int i = 1; i < users.size(); i++) {
            String username1 = users.get(i - 1).getUsername();
            String username2 = users.get(i).getUsername();
            Assert.isTrue(username1.compareTo(username2) > 0);
        }
    }

    @Test
    public void testFindByIdsPage() {

        List<User> users = userRepository.findAll();
        List<Long> ids = new ArrayList<Long>();
        for(User user: users) {
            ids.add(user.getId());
        }
        RequestPage page = new RequestPage(0, 2, new Sort(Direction.DESC, "username"));

        ResultPage<User> result = userRepository.find(ids, page);

        Assert.isTrue(result.getTotalElements() == NUMBER_OF_ITEMS);
        Assert.isTrue(result.getNumber() == 0);
        Assert.isTrue(result.getNumberOfElements() == 2);
        Assert.isTrue(result.getContent().size() == 2);
    }

    @Test
    public void testFindByCriteria() {

        DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
        criteria.add(
            Restrictions.or(
                Property.forName("username").eq("User 1"),
                Property.forName("username").eq("User 3")));

        List<User> users = userRepository.find(criteria);

        Assert.isTrue(users.size() == 2);
    }

    @Test
    public void testFindByCriteriaSortAsc() {

        DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
        criteria.add(
            Restrictions.or(
                Property.forName("username").eq("User 1"),
                Property.forName("password").eq("password5"),
                Property.forName("username").eq("User 3")));
        Sort sort = new Sort(Direction.ASC, "username");

        List<User> users = userRepository.find(criteria, sort);

        for(int i = 1; i < users.size(); i++) {
            String username1 = users.get(i - 1).getUsername();
            String username2 = users.get(i).getUsername();
            Assert.isTrue(username1.compareTo(username2) < 0);
        }
    }

    @Test
    public void testFindByCriteriaSortDesc() {

        DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
        criteria.add(
            Restrictions.or(
                Property.forName("username").eq("User 1"),
                Property.forName("password").eq("password5"),
                Property.forName("username").eq("User 3")));
        Sort sort = new Sort(Direction.DESC, "username");

        List<User> users = userRepository.find(criteria, sort);

        for(int i = 1; i < users.size(); i++) {
            String username1 = users.get(i - 1).getUsername();
            String username2 = users.get(i).getUsername();
            Assert.isTrue(username1.compareTo(username2) > 0);
        }
    }

    @Test
    public void testFindByCriteriaPage() {

        DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
        criteria.add(Restrictions.ilike("username", "User %"));
        RequestPage page = new RequestPage(2, 4, new Sort(Direction.DESC, "username"));

        ResultPage<User> result = userRepository.find(criteria, page);

        Assert.isTrue(result.getTotalElements() == NUMBER_OF_ITEMS);
        Assert.isTrue(result.getNumber() == 2);
        Assert.isTrue(result.getNumberOfElements() == 2);
        Assert.isTrue(result.getContent().size() == 2);
    }

    @Test
    public void testFindAll() {

        List<User> users = userRepository.findAll();

        Assert.isTrue(users.size() == NUMBER_OF_ITEMS);
    }

    @Test
    public void testFindAllSort() {

        Sort sort = new Sort(Direction.DESC, "username");

        List<User> users = userRepository.findAll(sort);

        Assert.isTrue(users.size() == NUMBER_OF_ITEMS);
        for(int i = 1; i < users.size(); i++) {
            String username1 = users.get(i - 1).getUsername();
            String username2 = users.get(i).getUsername();
            Assert.isTrue(username1.compareTo(username2) > 0);
        }
    }

    @Test
    public void testFindAllPageable() {

        RequestPage page = new RequestPage(0, 2, new Sort(Direction.DESC, "username"));

        ResultPage<User> result = userRepository.findAll(page);

        Assert.isTrue(result.getTotalElements() == NUMBER_OF_ITEMS);
        Assert.isTrue(result.getNumber() == 0);
        Assert.isTrue(result.getNumberOfElements() == 2);
        Assert.isTrue(result.getContent().size() == 2);
    }

    @Test
    public void testFindUniqueByField() {

        Util.createUser(userRepository, "user", "******", "role");

        User user = userRepository.findByUsername("user");

        Assert.isTrue(user != null);
        Assert.isTrue(user.getUsername().equals("user"));
    }

    @Test
    public void testFindByField() {

        Util.createUser(userRepository, "user1", "******", "role");
        Util.createUser(userRepository, "user2", "******", "role");

        List<User> users = userRepository.findByRoles("role");

        Assert.isTrue(users.size() == 2);
        Assert.isTrue(users.get(0).getRoles().equals("role"));
        Assert.isTrue(users.get(1).getRoles().equals("role"));
    }

    @Test
    public void testSave() {

        User user = Util.getUser("user", "password", "role");

        user = userRepository.save(user);

        Assert.isTrue("user".equals(user.getUsername()));
        Assert.isTrue("password".equals(user.getPassword()));
        Assert.isTrue("role".equals(user.getRoles()));
    }

    @Test(expected = org.hibernate.exception.ConstraintViolationException.class)
    public void testSaveTwice() {

        User user = Util.getUser("user", "password", "role");

        userRepository.save(user);
        userRepository.save(user);
    }

    @Test(expected = org.hibernate.exception.ConstraintViolationException.class)
    public void testSaveSameUnique() {

        User user1 = Util.getUser("user", "password1", "role");
        User user2 = Util.getUser("user", "password2", "role");

        userRepository.save(user1);
        userRepository.save(user2);
    }

    @Test(expected = javax.validation.ConstraintViolationException.class)
    public void testSaveNullNotNullable() {

        User user = Util.getUser(null, "password1", "role");

        userRepository.save(user);
    }

    @Test
    public void testSaveEmptyNotNullable() {

        User user = Util.getUser("", "password1", "role");

        user = userRepository.save(user);

        Assert.isTrue(user.getUsername().isEmpty());
    }

    @Test(expected = IllegalArgumentException.class)
    public void testSaveNullObject() {

        User user = null;

        userRepository.save(user);
    }

    @Test
    public void testSaveMultiple() {

        User user1 = Util.getUser("user1", "password1", "role");
        User user2 = Util.getUser("user2", "password2", "role");
        List<User> users = new ArrayList<User>();
        users.add(user1);
        users.add(user2);

        users = userRepository.save(users);

        Assert.isTrue(users.size() == 2);
        Assert.isTrue(users.get(0).getId().equals(user1.getId()) || users.get(0).getId().equals(user2.getId()));
        Assert.isTrue(users.get(1).getId().equals(user1.getId()) || users.get(1).getId().equals(user2.getId()));
    }

    @Test
    public void testUpdate() {

        User user = Util.createUser(userRepository, "user", "******", "role");
        user.setUsername("anonymous");

        user = userRepository.update(user);

        Assert.isTrue(user.getUsername().equals("anonymous"));
    }

    @Test(expected = TransientObjectException.class)
    public void testUpdateNoId() {

        User user = Util.createUser(userRepository, "user", "******", "role");
        user.setId(null);

        userRepository.update(user);
    }

    @Test(expected = HibernateException.class)
    public void testUpdateDiffrentId() {

        User user1 = Util.createUser(userRepository, "user", "******", "role");
        User user2 = (User) user1.clone();
        user2.setId(2L);

        userRepository.update(user2);
    }

    @Test(expected = HibernateException.class)
    public void testUpdateNonExisting() {

        User user = Util.createUser(userRepository, "user", "******", "role");
        user.setId(0xFFFFL);

        userRepository.update(user);
    }

    @Test(expected = HibernateException.class)
    public void testUpdateSameUnique() {

        Util.createUser(userRepository, "user1", "******", "role");
        User user2 = Util.createUser(userRepository, "user2", "******", "role");
        user2.setUsername("user1");

        userRepository.update(user2);
    }

    @Test(expected = javax.validation.ConstraintViolationException.class)
    public void testUpdateNullNotNullable() {

        User user = Util.createUser(userRepository, "user", "******", "role");
        user.setUsername(null);

        userRepository.update(user);
    }

    @Test
    public void testUpdateEmptyNotNullable() {

        User user = Util.createUser(userRepository, "user", "******", "role");
        user.setUsername("");

        userRepository.update(user);

        Assert.isTrue(user.getUsername().isEmpty());
    }

    @Test(expected = IllegalArgumentException.class)
    public void testUpdateNullObject() {

        User user = null;

        userRepository.update(user);
    }

    @Test
    public void testUpdateMultiple() {

        User user1 = Util.createUser(userRepository, "user1", "password1", "role");
        user1.setUsername("new_username_1");
        User user2 = Util.createUser(userRepository, "user2", "password2", "role");
        user2.setUsername("new_username_2");
        List<User> users = new ArrayList<User>();
        users.add(user1);
        users.add(user2);

        users = userRepository.update(users);

        Assert.isTrue(users.size() == 2);
        Assert.isTrue(users.get(0).getUsername().startsWith("new_username_"));
        Assert.isTrue(users.get(1).getUsername().startsWith("new_username_"));
    }

    @Test
    public void testUpdateByCriteria() {

        Util.createUser(userRepository, "user", "password", "role");
        DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
        criteria.add(Restrictions.eq("roles", "role"));
        User values = new User();
        values.setPassword("reset");

        List<User> users = userRepository.update(criteria, values);

        Assert.isTrue(users.size() == 1);
        Assert.isTrue(users.get(0).getRoles().equals("role"));
        Assert.isTrue(users.get(0).getPassword().equals("reset"));
        Assert.isTrue(users.get(0).getUsername().equals("user"));
    }

    @Test
    public void testDeleteById() {

        User user = Util.createUser(userRepository, "user", "password", "role");
        user = userRepository.find(user.getId());
        Assert.isTrue(user != null);

        userRepository.delete(user.getId());

        user = userRepository.find(user.getId());
        Assert.isTrue(user == null);
    }

    @Test(expected = ObjectNotFoundException.class)
    public void testDeleteByIdNonExistingId() {

        userRepository.delete(0xFFFFL);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testDeleteByIdNullId() {

        Long id = null;

        userRepository.delete(id);
    }

    @Test
    public void testDeleteByIds() {

        User user1 = Util.createUser(userRepository, "user1", "password1", null);
        User user2 = Util.createUser(userRepository, "user2", "password2", null);

        List<Long> ids = new ArrayList<Long>();
        ids.add(user1.getId());
        ids.add(user2.getId());

        userRepository.delete(ids);

        Assert.isTrue(!userRepository.exists(user1.getId()));
        Assert.isTrue(!userRepository.exists(user2.getId()));
    }

    @Test
    public void testDeleteByCriteria() {

        DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
        criteria.add(
            Restrictions.or(
                Property.forName("username").eq("User 1"),
                Property.forName("username").eq("User 3")));

        userRepository.delete(criteria);

        int size = userRepository.findAll().size();
        Assert.isTrue(size == NUMBER_OF_ITEMS - 2);
    }

    @Test
    public void testDeleteAll() {

        userRepository.deleteAll();

        int size = userRepository.findAll().size();
        Assert.isTrue(size == 0);
    }

    @Test
    public void testExists() {

        User user = Util.createUser(userRepository, "user", "password", null);

        boolean exists = userRepository.exists(user.getId());

        Assert.isTrue(exists);
    }

    @Test
    public void testDoesNotExists() {

        boolean exists = userRepository.exists(0xFFFFL);

        Assert.isTrue(!exists);
    }

    @Test
    public void testCountByCriteria() {

        DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
        criteria.add(
            Restrictions.or(
                Property.forName("username").eq("User 1"),
                Property.forName("username").eq("User 3")));

        long count = userRepository.count(criteria);

        Assert.isTrue(count == 2);
    }

    @Test
    public void testCountAll() {

        long count = userRepository.countAll();

        Assert.isTrue(count == NUMBER_OF_ITEMS);
    }

}
