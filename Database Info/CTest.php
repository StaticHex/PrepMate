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

// Create an array to hold our error message
$response = array();

if($_SERVER['REQUEST_METHOD']=='POST') {
	require_once 'DbOperation.php';
	$db = new DbOperation();
	$message = $db->conTest();
	if(strcmp($message, '')) {
		$response['error']=false;
	} else {
		$response['error']=true;
	}
	$response['message']=$message;
} else {
	$response['error']=true;
	$response['message']='Unauthorized access detected!';
}
echo json_encode($response);
?>