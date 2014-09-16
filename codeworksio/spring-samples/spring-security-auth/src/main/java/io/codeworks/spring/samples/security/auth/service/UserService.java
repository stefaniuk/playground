package io.codeworks.spring.samples.security.auth.service;

import io.codeworks.spring.common.model.User;
import io.codeworks.spring.samples.security.auth.dao.UserDao;

import java.util.List;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service("userService")
public class UserService implements UserDetailsService {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    UserDao userDao;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public User loadUserByUsername(String username) throws UsernameNotFoundException {

        logger.debug("load user by username " + username);

        return userDao.fetchByUsername(username);
    }

    public boolean isPasswordEncoded(User user) {

        Pattern pattern = Pattern.compile("\\A\\$2a?\\$\\d\\d\\$[./0-9A-Za-z]{53}");

        return pattern.matcher(user.getPassword()).matches();
    }

    public void encodePassword(User user) {

        logger.debug("encode password for user " + user);

        if(user.getPassword() != null && !isPasswordEncoded(user)) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
            userDao.update(user);
        }
    }

    public void encodePasswords() {

        logger.debug("encode user passwords");

        List<User> users = userDao.fetchAll();
        for(User user: users) {
            encodePassword(user);
        }
    }

}
