<?php 
                   
$accountID = 403651;
$username = null;
$password = null;
$error = null;

if (isset($_GET["username"])) {
	$username = $_GET["username"];
} else {
	$error = "USERNAME NOT SET";
}

if (isset($_GET["password"])) {
	$password = $_GET["password"];
} else {
	$error = "PASSWORD NOT SET";
}

$sessionID = getSessionID($username, $password, $accountID);
$eventID = getEventID($sessionID, $accountID);

$info = getUserInfo($sessionID, $eventID);

if (isset($error)) {
	
} else {
	echo json_encode($info);	
}

function getSessionID($username, $password, $accountID) {

	$url = "https://www.kintera.org/api/Authentication/Login.ashx?accountid=".$accountID;
	$data = array('username' => $username,'password' => $password);
	$options = array(
    	'http' => array(
        	'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
			'method'  => 'POST',
			'content' => http_build_query($data)));

	$context  = stream_context_create($options);
	$result = file_get_contents($url, false, $context);
	$xml = simplexml_load_string($result);

	if (isset($xml->ErrorMessage)) {
		return false;
	} else {
		if (isset($xml->SessionId)) {
			return $xml->SessionId;
		} else {
			return false;
		}
	}
}

function getEventID($sessionID, $accountID) {

	$url = "http://www.kintera.org/api/friendsaskingfriends/Account.ashx?accountid=".$accountID."&sessionid=".$sessionID;
	$options = array(
    	'http' => array(
        	'header'  => "Content-type: application/x-www-form-urlencoded\r\n"));

	$context  = stream_context_create($options);
	$result = file_get_contents($url, false, $context);
	$xml = simplexml_load_string($result);	

	if (isset($xml->ErrorMessage)) {
		$error = $xml->ErrorMessage;
		return false;
	} else {
		$accountEvents = $xml->AccountEvents;
		$accountEvent = $accountEvents->AccountEvent;
		for ($i = 0; $i < count($accountEvent); $i++) {
			if ($accountEvent[$i]->EventName == "Dance Marathon at UF 2015") {
				return $accountEvent[$i]->EventID;
			}
		}
	}
	return false;
}

function getUserInfo($sessionID, $eventID) {
	$url = "http://www.kintera.org/api/FriendsAskingFriends/Info.ashx?eventid=".$eventID."&sessionid=".$sessionID;
	$options = array(
    	'http' => array(
        	'header'  => "Content-type: application/x-www-form-urlencoded\r\n"));

	$context  = stream_context_create($options);
	$result = file_get_contents($url, false, $context);
	$xml = simplexml_load_string($result);	

	if (isset($xml->ErrorMessage)) {
		$error = $xml->ErrorMessage;
		return false;
	} else {
		// Dump raw XML Data
/* 		var_dump($xml); */
		return $xml;
	}
	return false;
}
?>