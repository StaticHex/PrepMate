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
class DbConnect {
	private $conn;
	
	// Constructor function
	function __construct() {
	}
	
	/**
	* Connect Function
	* @desc
	* - Tries to create a connection to the defined
	*   database
	**/
	function connect() {
		require_once 'Config.php';
		
		// connect to database
		$this->conn = new mysqli(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME);
		
		//Check for errors
		if (mysqli_connect_errno()) {
			echo "Failed to connect to DB: " . mysqli_connect_error();
		} else {
			echo "Connection success!";
		}
		// return connection
		return $this->conn;
	}
	
	function conTest() {
		$this->conn = new mysqli(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME);
		if (mysqli_connect_errorno()) {
			return mysqli_connect_error();
		} else {
			return '';
		}
	}
}
?>