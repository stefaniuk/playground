<?php

class Code4ge_CMF_Acl extends Zend_Acl
{

	const CREATE  = 'create';

	const READ = 'read';

	const UPDATE = 'update';

	const DELETE  = 'delete';

	public function __construct()
	{
		// get roles
		$roleGateway = Code4ge_CMF_Model_AclRoleGateway::getInstance();
		$roles = $roleGateway->getList();
		foreach($roles as $role) {
			if(isset($role->nameParent)) {
				$this->addRole($role, $role->nameParent);
			}
			else {
				$this->addRole($role);
			}
		}

		// get action resources from database
		$resourceGateway = Code4ge_CMF_Model_AclResourceGateway::getInstance();
		$resources = $resourceGateway->getList();
		foreach($resources as $resource) {
			// create resource object
			$obj = new Code4ge_CMF_Acl_Resource($resource->name, $resource->type);
			// save resource in acl
			if(isset($resource->nameParent)) {
				$this->add($obj, $resource->nameParent);
			}
			else {
				$this->add($obj);
			}
		}

		// get permissions from database
		$permissionGateway = Code4ge_CMF_Model_AclPermissionGateway::getInstance();
		$permissions = $permissionGateway->getList();
		foreach($permissions as $permission) {
			// create resource object
			$resource = new Code4ge_CMF_Acl_Resource($permission->resourceName, $permission->resourceType);
			// save permission in acl
			if($permission->access == 'allow') {
				// allow
				$this->allow($permission->roleName, $resource, $permission->privilege);
			}
			else if($permission->access == 'deny') {
				// deny
				$this->deny($permission->roleName, $resource, $permission->privilege);
			}
		}		
	}

	/* ====================================================================== */

	public function add(Zend_Acl_Resource_Interface $resource, $parent = null)
	{
		if($parent != null) {
			$parent = $this->getResource($parent);
		}

		return $this->addResource($resource, $parent);
	}

	public function isAllowed($role = null, $resource = null, $privilege = null)
	{
		$resource = $this->getResource($resource);

		return parent::isAllowed($role, $resource, $privilege);
	}

	/* ====================================================================== */

	public function hasAction($resource)
	{
		if(is_string($resource)) {
			$resource = new Code4ge_CMF_Acl_Resource($resource, Code4ge_CMF_Acl_Resource::ACTION);
		}

		return $this->has($resource);
	}

	public function isActionAllowed($role = null, $resource = null)
	{
		if(is_string($resource)) {
			$resource = new Code4ge_CMF_Acl_Resource($resource, Code4ge_CMF_Acl_Resource::ACTION);
		}

		return $this->isAllowed($role, $resource, self::READ);
	}

	public function getModelPermission($role, $model)
	{
		$mug = Code4ge_CMF_Model_AclModelGateway::getInstance();
		$model = $mug->fetchByName($model);

		$permission = array();
		if(isset($model->create) && $this->isActionAllowed($role, $model->create)) {
			$permission[self::CREATE] = $model->create;
		}
		if(isset($model->read) && $this->isActionAllowed($role, $model->read)) {
			$permission[self::READ] = $model->read;
		}
		if(isset($model->update) && $this->isActionAllowed($role, $model->update)) {
			$permission[self::UPDATE] = $model->update;
		}
		if(isset($model->delete) && $this->isActionAllowed($role, $model->delete)) {
			$permission[self::DELETE] = $model->delete;
		}

		return $permission;
	}

	/* ====================================================================== */

	private function getResource($resource)
	{
		if(is_string($resource)) {
			$type = $this->getResourceType($resource);
			if($type == Code4ge_CMF_Acl_Resource::ACTION) {
				$resource = new Code4ge_CMF_Acl_Resource($resource, Code4ge_CMF_Acl_Resource::ACTION);
			}
			else {
				throw new Exception('Custom resource can not be a string');
			}
		}
		else if(!($resource instanceof Code4ge_CMF_Acl_Resource)) {
			throw new Exception('Bad resource object');
		}

		return $resource;
	}

	private function getResourceType($str)
	{
		return '/'==substr($str, 0, 1) ? Code4ge_CMF_Acl_Resource::ACTION : Code4ge_CMF_Acl_Resource::CUSTOM;
	}

}

