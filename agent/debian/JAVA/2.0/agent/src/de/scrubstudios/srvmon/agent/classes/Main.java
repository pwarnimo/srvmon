/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
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
 *
 * @author pwarnimo
 */
public class Main {
    private static int hostid = 0;
    private static ResourceBundle lang = ResourceBundle.getBundle("de/scrubstudios/srvmon/agent/resource/Lang");
    
    private static void printVersion() {
        System.out.println(lang.getString("Agent.Version"));
    }
    
    /**
     * @param args the command line arguments
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
