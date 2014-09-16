package io.codeworks.commons.test.application;

import io.codeworks.commons.data.repository.HibernateRepository;

import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public class UserRepository extends HibernateRepository<User> {

    public User findByUsername(String username) {

        return findUniqueByField("username", username);
    }

    public List<User> findByRoles(String roles) {

        return findByField("roles", roles);
    }

}
