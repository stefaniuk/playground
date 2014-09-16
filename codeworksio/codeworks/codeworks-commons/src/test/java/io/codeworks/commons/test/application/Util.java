package io.codeworks.commons.test.application;

public class Util {

    public static User createUser(UserRepository userRepository, String username, String password, String roles) {

        User user = getUser(username, password, roles);
        user = userRepository.save(user);

        return user;
    }

    public static User getUser(String username, String password, String roles) {

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRoles(roles);

        return user;
    }

}
