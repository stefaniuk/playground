package io.codeworks.commons.test.commons.util;

import io.codeworks.commons.commons.util.ObjectUtil;
import io.codeworks.commons.test.Config;
import io.codeworks.commons.test.application.User;
import io.codeworks.commons.test.application.Util;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = { Config.class })
public class ObjectUtilTest {

    @Test
    public void testCloneObject() {

        User user = new User();
        user.setId(1L);
        user.setUsername("user");

        User u = ObjectUtil.clone(user);

        Assert.isTrue(user != u);
        Assert.isTrue(user.getId().equals(u.getId()));
        Assert.isTrue(user.getUsername().equals(u.getUsername()));
    }

    @Test
    public void testCopyBeanProperties() {

        String roles = "roleA,roleB";
        User user1 = Util.getUser("user", null, roles);
        User user2 = Util.getUser("user", null, "none");

        ObjectUtil.copyBeanProperties(user1, user2);

        Assert.isTrue(user2.getUsername().equals("user"));
        Assert.isTrue(user2.getPassword() == null);
        Assert.isTrue(user1.getRoles().equals(roles));
        Assert.isTrue(user2.getRoles().equals(roles));
    }

    @Test
    public void testCopyBeanPropertiesIgnoreNulls() {

        String roles = "roleA,roleB";
        User user1 = Util.getUser(null, null, roles);
        User user2 = Util.getUser("user", "password", null);

        ObjectUtil.copyBeanProperties(user1, user2);

        Assert.isTrue(user2.getUsername().equals("user"));
        Assert.isTrue(user2.getPassword().equals("password"));
        Assert.isTrue(user2.getRoles().equals(roles));
    }

}
