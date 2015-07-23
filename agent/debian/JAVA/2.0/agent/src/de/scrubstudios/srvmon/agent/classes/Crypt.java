/*
 * File        : Crypt.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 2.0 P1
 * Description : This file is part of the SRVMON AGENT.
 *               This class is used for the encryption between the Client and
 *               Server.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
 *  2015-05-15 : Preparing for v1.0.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-23 : Reworking agent completely.
 *
 * License information
 * -------------------
 *  Copyright (C) 2015  Pol Warnimont
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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

/**
 * This class is used for the encryption between the Server and the Agent.
 * @author Pol Warnimont
 * @version 2.0
 */
public class Crypt {
    /**
     * This function is used to encrypt the outgoing data.
     * @param key Encryption key
     * @param data Data which will be encrypted.
     * @return The encrypted data string.
     */
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
    
    /**
     * This function is used to decrypt incoming data.
     * @param key Encryption key
     * @param data Data string which should be decrypted.
     * @return The decrypted data string.
     */
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
