package io.codeworks.spring.common.model.acl;


import io.codeworks.spring.common.model.AbstractModel;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * Finally, ACL_ENTRY stores the individual permissions assigned to each
 * recipient. Columns include a foreign key to the ACL_OBJECT_IDENTITY, the
 * recipient (ie a foreign key to ACL_SID), whether we'll be auditing or not,
 * and the integer bit mask that represents the actual permission being granted
 * or denied. We have a single row for every recipient that receives a
 * permission to work with a domain object.
 * 
 * @see <a
 *      href="http://docs.spring.io/autorepo/docs/spring-security/3.1.x/reference/domain-acls.html"
 *      >Domain Object Security (ACLs)</a>
 */
@Entity
@Table(
    name = "acl_entry",
    uniqueConstraints = @UniqueConstraint(columnNames = { "aclObjectIdentity", "aceOrder" }))
public class AclEntry extends AbstractModel {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", unique = true, nullable = false)
    private Integer id;

    private Integer aclObjectIdentity;

    private Integer aceOrder;

    private Integer sid;

    private Integer mask;

    private Integer granting;

    private Integer auditSuccess;

    private Integer auditFailure;

    @Override
    public Integer getId() {

        return id;
    }

    @Override
    public void setId(Integer id) {

        this.id = id;
    }

    public Integer getAclObjectIdentity() {

        return aclObjectIdentity;
    }

    public void setAclObjectIdentity(Integer aclObjectIdentity) {

        this.aclObjectIdentity = aclObjectIdentity;
    }

    public Integer getAceOrder() {

        return aceOrder;
    }

    public void setAceOrder(Integer aceOrder) {

        this.aceOrder = aceOrder;
    }

    public Integer getSid() {

        return sid;
    }

    public void setSid(Integer sid) {

        this.sid = sid;
    }

    public Integer getMask() {

        return mask;
    }

    public void setMask(Integer mask) {

        this.mask = mask;
    }

    public Integer getGranting() {

        return granting;
    }

    public void setGranting(Integer granting) {

        this.granting = granting;
    }

    public Integer getAuditSuccess() {

        return auditSuccess;
    }

    public void setAuditSuccess(Integer auditSuccess) {

        this.auditSuccess = auditSuccess;
    }

    public Integer getAuditFailure() {

        return auditFailure;
    }

    public void setAuditFailure(Integer auditFailure) {

        this.auditFailure = auditFailure;
    }

}
