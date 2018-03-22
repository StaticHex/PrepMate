<?php
/**
* REST API for PrepMate
* Course: CS 371L
* Team: 2
* Members:
* - Joseph Bourque
* - Yen Chen Wee
* - Pablo Velasco
* Created on: 03/16/2018
**/
class DbOperation {
	private $conn;
	
	// Constructor
	function __construct() {
		require_once dirname(__FILE__) . '/Config.php';
		require_once dirname(__FILE__) . '/DbConnect.php';
		
		// open a new connection
		$db = new DbConnect();
		$this->conn = $db->connect();
	}
	
	function conTest() {
		require_once dirname(__FILE__) . '/Config.php';
		require_once dirname(__FILE__) . '/DbConnect.php';
		
		// open a new connection
		$db = new DbConnect();
		return $db->conTest();
	}
}
?>