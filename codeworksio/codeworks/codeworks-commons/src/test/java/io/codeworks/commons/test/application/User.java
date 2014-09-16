package io.codeworks.commons.test.application;

import io.codeworks.commons.data.annotation.DoNotShow;
import io.codeworks.commons.data.model.Model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Entity
@Table(
    name = "UserAccount",
    indexes = {
        @Index(columnList = "username", unique = true, name = "user_username")
    })
public class User extends Model {

    private static final long serialVersionUID = 6481800607293674622L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(unique = true, nullable = false)
    @NotNull
    @Size(max = 30)
    private String username;

    @NotNull
    @Size(max = 256)
    @DoNotShow
    private String password;

    private String roles;

    @Override
    public Long getId() {

        return this.id;
    }

    @Override
    public void setId(Long id) {

        this.id = id;
    }

    public String getUsername() {

        return username;
    }

    public void setUsername(String username) {

        this.username = username;
    }

    public String getPassword() {

        return password;
    }

    public void setPassword(String password) {

        this.password = password;
    }

    public String getRoles() {

        return roles;
    }

    public void setRoles(String roles) {

        this.roles = roles;
    }

}
