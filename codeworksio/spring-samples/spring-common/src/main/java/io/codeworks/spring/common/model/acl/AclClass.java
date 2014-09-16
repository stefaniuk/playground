package io.codeworks.spring.common.model.acl;


import io.codeworks.spring.common.model.AbstractModel;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

/**
 * ACL_CLASS allows us to uniquely identify any domain object class in the
 * system. The only columns are the ID and the Java class name. Thus, there is a
 * single row for each unique Class we wish to store ACL permissions for.
 * 
 * @see <a
 *      href="http://docs.spring.io/autorepo/docs/spring-security/3.1.x/reference/domain-acls.html"
 *      >Domain Object Security (ACLs)</a>
 */
@Entity
@Table(name = "acl_class")
public class AclClass extends AbstractModel {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", unique = true, nullable = false)
    private Integer id;

    @Column(nullable = false, unique = true)
    @Size(max = 200)
    private String clazz;

    @Override
    public Integer getId() {

        return id;
    }

    @Override
    public void setId(Integer id) {

        this.id = id;
    }

    public String getClazz() {

        return clazz;
    }

    public void setClazz(String clazz) {

        this.clazz = clazz;
    }

}
