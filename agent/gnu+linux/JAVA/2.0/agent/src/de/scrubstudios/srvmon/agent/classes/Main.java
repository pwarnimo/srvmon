/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 2.0 P1
 * Description : This file is part of the SRVMON agent.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-09 : Created class.
 *  2015-05-11 : Added test functions.
 *               Added Javadoc.
 *  2015-05-15 : Preparing agent 1.0.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-23 : Completely reworking agent.
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

package de.scrubstudios.srvmon.agent.classes;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.sql.Timestamp;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

/** 
 * Main class for the SRVMON AGENT.
 * @author Pol Warnimont
 * @version 2.0
 */
public class Main {
    /** Host ID for the current agent. */
    private static int hostid = 0;
    /** Resource bundle for the multi-language support. */
    private static final ResourceBundle lang = ResourceBundle.getBundle("de/scrubstudios/srvmon/agent/resource/Lang");
    
    /**
     * This method prints out the version of the agent.
     */
    private static void printVersion() {
        System.out.println(lang.getString("Agent.Version"));
    }
    
    /**
     * Main method of the class.
     * The program will enter in an endless loop. Every 300*1000 milliseconds, a 
     * thread will be executed which will perform the service checks. The check 
     * interval can be defined by the user in the config file.
     * @param args Command line arguments. If -v -> return version.
     */
    public static void main(String[] args) {
        if (args.length > 0) {
            switch (args[0]) {
                case "-v":
                    printVersion();
                    
                    break;
            }
        }
        else {
            printVersion();
            System.out.println(new Timestamp(System.currentTimeMillis()) + " > " + lang.getString("Agent.WelcomeMsg"));
            
            File f = new File("/etc/srvmon/agent.properties");
            Properties prop = new Properties();
            
            if (f.exists()) {
                try {
                    InputStream in = new FileInputStream("/etc/srvmon/agent.properties");
                    
                    prop.load(in);
                    
                    hostid = XML.getInstance().getHostID(prop.getProperty("agent.hostname"));
                    
                    switch (hostid) {
                        case -3:
                            System.out.println(new Timestamp(System.currentTimeMillis()) + " * " + lang.getString("Agent.SQLException"));
                            
                            break;
                            
                        case -4:
                            System.out.println(new Timestamp(System.currentTimeMillis()) + " * " + lang.getString("Agent.SQLWarning"));
                            
                            break;
                            
                        case -5:
                            System.out.println(new Timestamp(System.currentTimeMillis()) + " * " + lang.getString("Agent.HostNotExisiting"));
                            
                            break;
                            
                        default:
                            while (true) {
                                System.out.println(new Timestamp(System.currentTimeMillis()) + " > " + lang.getString("Agent.WakeUp"));
                                
                                new Worker(hostid).start();
                                
                                System.out.println(new Timestamp(System.currentTimeMillis()) + " > " + lang.getString("Agent.Sleeping"));
                                
                                Thread.sleep(Integer.parseInt(prop.getProperty("agent.interval")) * 1000);
                            }
                    }
                } catch (FileNotFoundException ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                } catch (IOException | InterruptedException ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            else {
                System.out.println(lang.getString("Agent.ConfigNotExisting"));
                
                try {
                    OutputStream out = new FileOutputStream("/etc/srvmon/agent.properties");
                    
                    prop.setProperty("director.url", "https://change.me/director/");
                    prop.setProperty("agent.interval", "300");
                    prop.setProperty("agent.username", "john.doe");
                    prop.setProperty("agent.password", "mypass123.");
                    prop.setProperty("agent.enckey", "eNcRyPtIoNkEy123");
                    prop.setProperty("agent.hostname", InetAddress.getLocalHost().getHostName());
                    
                    prop.store(out, null);
                } catch (FileNotFoundException ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                } catch (IOException ex) {
                    Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
}
