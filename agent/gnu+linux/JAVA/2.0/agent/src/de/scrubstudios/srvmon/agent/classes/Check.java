/*
 * File        : Check.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 2.0 P1
 * Description : This file is part of the SRVMON AGENT.
 *               This class defines a service check.
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
 * This class is used for service checks.
 * With the help of this class, the agent is able to execute the available 
 * service check scripts. The scripts are located in the 
 * /usr/share/srvmon/checkscripts directory.
 * @author Pol Warnimont
 * @version 2.0
 */
public class Check {
    /**
     * This method executes a single service check which is given by the check 
     * parameter. The method creates a new process for the check script and sets 
     * then parses the output of the executed check script.
     * @param service Service check.
     */
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
    
    /**
     * This method is used to check if a checkscript has been modified. The
     * check works by calculating the SHA1 hash of the file and by then 
     * comparing the calculated hash with the hash stored in the DB.
     * @param hostid Current host ID of the agent.
     * @param service Current service.
     * @param checksum Checksum of the current service.
     * @return TRUE if the checksum is valid, else returns FALSE.
     */
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
            StringBuilder sb = new StringBuilder("");
            
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
