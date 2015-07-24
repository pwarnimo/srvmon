/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.2 P1
 * Description : This file is part of the SRVMON director.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-05 : Created class.
 *  2015-05-07 : Finalized director updater.
 *  2015-05-08 : Added javadoc.
 *  2015-05-12 : Starting version 1.1.
 *  2015-05-13 : Bugfixing.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-23 : Preparing for package release.
 *               Project converted to Netbeans proj.
 *               Added multilang support.
 *  2015-07-24 : Preparing for package release.
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

package de.scrubstudios.srvmon.director.updater.classes;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Main class for the SRVMON Director Updater.
 * @author Pol Warnimont
 * @version 1.2
 */
public class Main {
    /** Resource bundle for the multi-language support. */
    private static final ResourceBundle lang = ResourceBundle.getBundle("de/scrubstudios/srvmon/director/updater/resources/Lang");
    
    /**
     * This method prints out the current version of the application.
     */
    private static void printVersion() {
        System.out.println(lang.getString("Director.Version"));
    }
    
    /**
     * The main method enters a while loop which will run until the program 
     * execution is canceled. Inside the loop, a new worker thread will be 
     * created every 5 minutes (300*1000s). If the method is unable to find the 
     * properties file, a sample file will be generated and the program exits.
     * The user then has to set the appropriate values inside the file.
     * @param args Command line arguments. If -v -> return version.
     */
    public static void main(String[] args) {
        if (args.length > 0) {
            if (args[0].equals("-v")) {
                printVersion();
            }
	}
        else {
            printVersion();
            
            System.out.println(new Timestamp(System.currentTimeMillis()) + " > " + lang.getString("Director.Init"));
            
            File f = new File("/etc/srvmon/director.properties");
            Properties prop = new Properties();
            
            if (f.exists()) {
                System.out.println(new Timestamp(System.currentTimeMillis()) + " > " + lang.getString("Director.FileExists"));
				
                try {
                    prop.load(new FileInputStream("/etc/srvmon/director.properties"));
                    
                    while (true) {
                        System.out.println(new Timestamp(System.currentTimeMillis()) + " > " + lang.getString("Director.ThreadStart"));
                        new Worker().run();
                        System.out.println(new Timestamp(System.currentTimeMillis()) + " > " + lang.getString("Director.Inactive"));
                        Thread.sleep(Integer.parseInt(prop.getProperty("director.interval")) * 1000);
                    }
                } catch (IOException | InterruptedException ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            else {
                System.out.println(lang.getString("Director.NoFile"));

                try {
                    prop.setProperty("db.hostname", "127.0.0.1");
                    prop.setProperty("db.username", "username");
                    prop.setProperty("db.password", "P@ssw0rD!");
                    prop.setProperty("db.name", "dbname");
                    prop.setProperty("director.interval", "300");

                    prop.store(new FileOutputStream("/etc/srvmon/director.properties"), null);
                } catch (IOException ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
}
