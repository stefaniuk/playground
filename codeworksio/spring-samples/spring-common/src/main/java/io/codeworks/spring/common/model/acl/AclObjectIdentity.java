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
 * ACL_OBJECT_IDENTITY stores information for each unique domain object instance
 * in the system. Columns include the ID, a foreign key to the ACL_CLASS table,
 * a unique identifier so we know which ACL_CLASS instance we're providing
 * information for, the parent, a foreign key to the ACL_SID table to represent
 * the owner of the domain object instance, and whether we allow ACL entries to
 * inherit from any parent ACL. We have a single row for every domain object
 * instance we're storing ACL permissions for.
 * 
 * @see <a
 *      href="http://docs.spring.io/autorepo/docs/spring-security/3.1.x/reference/domain-acls.html"
 *      >Domain Object Security (ACLs)</a>
 */
@Entity
@Table(
    name = "acl_object_identity",
    uniqueConstraints = @UniqueConstraint(columnNames = { "objectIdClass", "objectIdIdentity" }))
public class AclObjectIdentity extends AbstractModel {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", unique = true, nullable = false)
    private Integer id;

    private Integer objectIdClass;

    private Integer objectIdIdentity;

    private Integer parentObject;

    private Integer ownerSid;

    private Integer entriesInheriting;

    @Override
    public Integer getId() {

        return id;
    }

    @Override
    public void setId(Integer id) {

        this.id = id;
    }

    public Integer getObjectIdClass() {

        return objectIdClass;
    }

    public void setObjectIdClass(Integer objectIdClass) {

        this.objectIdClass = objectIdClass;
    }

    public Integer getObjectIdIdentity() {

        return objectIdIdentity;
    }

    public void setObjectIdIdentity(Integer objectIdIdentity) {

        this.objectIdIdentity = objectIdIdentity;
    }

    public Integer getParentObject() {

        return parentObject;
    }

    public void setParentObject(Integer parentObject) {

        this.parentObject = parentObject;
    }

    public Integer getOwnerSid() {

        return ownerSid;
    }

    public void setOwnerSid(Integer ownerSid) {

        this.ownerSid = ownerSid;
    }

    public Integer getEntriesInheriting() {

        return entriesInheriting;
    }

    public void setEntriesInheriting(Integer entriesInheriting) {

        this.entriesInheriting = entriesInheriting;
    }

}
