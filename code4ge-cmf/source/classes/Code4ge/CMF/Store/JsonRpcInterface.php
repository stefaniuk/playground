<?php

interface Code4ge_CMF_Store_JsonRpcInterface {

	public function select($options);

	public function update($key, $data);

	public function insert($key, $data);

	public function delete($key);

}
