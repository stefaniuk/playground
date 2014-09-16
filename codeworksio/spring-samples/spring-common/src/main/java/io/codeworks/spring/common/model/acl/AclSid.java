package io.codeworks.spring.common.model.acl;


import io.codeworks.spring.common.model.AbstractModel;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;
import javax.validation.constraints.Size;

/**
 * ACL_SID allows us to uniquely identify any principal or authority in the
 * system ("SID" stands for "security identity"). The only columns are the ID, a
 * textual representation of the SID, and a flag to indicate whether the textual
 * representation refers to a principal name or a GrantedAuthority. Thus, there
 * is a single row for each unique principal or GrantedAuthority. When used in
 * the context of receiving a permission, a SID is generally called a
 * "recipient".
 * 
 * @see <a
 *      href="http://docs.spring.io/autorepo/docs/spring-security/3.1.x/reference/domain-acls.html"
 *      >Domain Object Security (ACLs)</a>
 */
@Entity
@Table(
    name = "acl_sid",
    uniqueConstraints = @UniqueConstraint(columnNames = { "principal", "sid" }))
public class AclSid extends AbstractModel {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", unique = true, nullable = false)
    private Integer id;

    @Column(nullable = false)
    private Integer principal;

    @Column(nullable = false)
    @Size(max = 100)
    private String sid;

    @Override
    public Integer getId() {

        return id;
    }

    @Override
    public void setId(Integer id) {

        this.id = id;
    }

    public Integer getPrincipal() {

        return principal;
    }

    public void setPrincipal(Integer principal) {

        this.principal = principal;
    }

    public String getSid() {

        return sid;
    }

    public void setSid(String sid) {

        this.sid = sid;
    }

}
