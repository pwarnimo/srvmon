/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.agent.classes;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author pwarnimo
 */
public class Check {
    public static void executeCheck(Service service) {
        try {
            Process p = Runtime.getRuntime().exec("/usr/share/srvmon/checkscripts/" + service.getCmd() + " " + service.getParameters());
            
            p.waitFor();
            
            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line = "";
            
            while ((line = br.readLine()) != null) {
                String[] output = line.split(";");
                
                service.setValue(Integer.parseInt(output[0]));
                service.setCheckOutput(output[1]);
            }
        } catch (IOException | InterruptedException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public static boolean isValid(int hostid, Service service, String checksum) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA1");
            FileInputStream fis = new FileInputStream("/usr/share/srvmon/checkscripts/" + service.getCmd());
            byte[] dataBytes = new byte[1024];
            int nread = 0;
            
            while ((nread = fis.read(dataBytes)) != -1) {
                md.update(dataBytes, 0, nread);
            }
            
            byte[] mdBytes = md.digest();
            StringBuffer sb = new StringBuffer("");
            
            for (int i = 0; i < mdBytes.length; i++) {
                sb.append(Integer.toString((mdBytes[i] & 0xff) + 0x100, 16).substring(1));
            }
            
            if (checksum.equals(sb.toString())) {
                return true;
            }
        } catch (NoSuchAlgorithmException | FileNotFoundException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }
}
