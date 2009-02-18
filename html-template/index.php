<?php
$MAXIMUM_FILESIZE   = 1024 * 200; // 200KB
$MAXIMUM_FILE_COUNT = 10; // keep maximum 10 files on server
$UPLOAD_TREE_PARAM  = 'GetTree';
$UPLOAD_FILE_PARAM  = 'FileName';
$UPLOAD_PATH_PARAM  = 'FilePath';
$UPLOAD_DIRECTORY   = 'images/';
$REMOVE_PATH_PARAM  = 'RemovePath';

$domain='http://'.$_SERVER['HTTP_HOST'];

if(isset($_FILES[$UPLOAD_FILE_PARAM])){
	if($_FILES[$UPLOAD_FILE_PARAM]['size'] <= $MAXIMUM_FILESIZE){
		$path = $_GET[$UPLOAD_PATH_PARAM];
		$path = preg_replace("#^$UPLOAD_DIRECTORY#", '', $path);
		$path = $UPLOAD_DIRECTORY.$path;
		move_uploaded_file($_FILES[$UPLOAD_FILE_PARAM]['tmp_name'], $path.$_FILES[$UPLOAD_FILE_PARAM]['name']);
	}
}elseif(isset($_GET[$UPLOAD_TREE_PARAM])){
	$xml = '<?'.'xml version="1.0" encoding="utf-8"'.'?>';
	$xml .=getFileXmlTree($UPLOAD_DIRECTORY);
	echo $xml;
}elseif(isset($_GET[$REMOVE_PATH_PARAM])){
	$path = $_GET[$REMOVE_PATH_PARAM];
	$path = preg_replace("#^$UPLOAD_DIRECTORY#", '', $path);
	$path = $UPLOAD_DIRECTORY.$path;
	logData('remove '.$path);
	removeFile($path);
}else echo file_get_contents('flexrtf.html');

function removeFile($path){
	if(is_dir($path)){
		$dir = opendir($path);
		while($file = readdir($dir)){
			if($file=='.'||$file=='..')continue;
			if(is_dir($path.$file))removeFile($path.$file.'/');
			else @unlink($path.$file);
		}
		closedir($dir);
		@rmdir($path);
	}else @unlink($path);
}
function getFileXmlTree($path){
	global $domain;
	$label = split('/', preg_replace('/\/+$/','',$path));
	$label = $label[sizeof($label)-1];

	$xmlDirs = '';
	$xmlFiles = '';
	$dir = opendir($path);
	while($file = readdir($dir)){
		if($file=='.'||$file=='..')continue;
		if(is_dir($path.$file))$xmlDirs.=getFileXmlTree($path.$file.'/');
		else $xmlFiles.='<node label="'.$file.'" path="'.($path).'" url="'.$domain.'/flexrtf/'.($path.$file).'" size="'.filesize($path.$file).'"/>';
	}
	closedir($dir);
	return '<node label="'.$label.'" path="'.$path.'" isBranch="true">'.$xmlDirs.$xmlFiles.'</node>';
}
function logData($msg){
	$fp = fopen('./data.txt', 'a');
	fwrite($fp, $msg."\n");
	fclose($fp);
}
?>