package de.scrubstudios.srvmon.agent.classes;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author pwarnimo
 */
public class Crypt {
    public static String encrypt(String key, String data) {
        byte[] encryptedData = null;
        SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
        
        try {
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            
            cipher.init(Cipher.ENCRYPT_MODE, keySpec);
            encryptedData = cipher.doFinal(data.getBytes());
            
            return new String(Base64.encodeBase64(encryptedData));
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException ex) {
            Logger.getLogger(Crypt.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
    
    public static String decrypt(String key, String data) {
        byte[] decryptedData = null;
        SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
        
        try {
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            
            cipher.init(Cipher.DECRYPT_MODE, keySpec);
            decryptedData = cipher.doFinal(Base64.decodeBase64(data));
            
            return new String(decryptedData);
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException ex) {
            Logger.getLogger(Crypt.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
}
