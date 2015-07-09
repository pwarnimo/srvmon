<?php
class Encryptor {
	private static function pkcs5_pad($text, $blocksize) { 
		$pad = $blocksize - (strlen($text) % $blocksize); 
		return $text . str_repeat(chr($pad), $pad); 
	}

	public static function encryptData($key, $data) {
		$size = mcrypt_get_block_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_ECB);
		$data = Encryptor::pkcs5_pad($data, $size); 
		$td = mcrypt_module_open(MCRYPT_RIJNDAEL_128, '', MCRYPT_MODE_ECB, ''); 
		$iv = mcrypt_create_iv (mcrypt_enc_get_iv_size($td), MCRYPT_RAND); 
		mcrypt_generic_init($td, $key, $iv); 
		$encryptedData = mcrypt_generic($td, $data); 
		mcrypt_generic_deinit($td); 
		mcrypt_module_close($td);
		$encryptedData = base64_encode($encryptedData); 
		return $encryptedData;
	}

	public static function decryptData($key, $data) {
		$decryptedData= mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, base64_decode($data), MCRYPT_MODE_ECB);
		$dec_s = strlen($decryptedData);
		$padding = ord($decryptedData[$dec_s-1]);
		$decryptedData = substr($decryptedData, 0, -$padding);
		return $decryptedData;
	}
}
