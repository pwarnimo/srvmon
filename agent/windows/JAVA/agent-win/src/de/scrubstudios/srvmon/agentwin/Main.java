/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-07-03
 * Version     : 0.5
 * Description : This file is part of the SRVMON agent.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-07-03 : Created class.
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

package de.scrubstudios.srvmon.agentwin;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Properties;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.nt.NTEventLogAppender;

/** 
 * Main class for the SRVMON AGENT.
 * @author Pol Warnimont
 * @version 0.5
 */
public class Main {
	/** Host ID for the current agent. */
	private static int _host_id = 0;
	/** Windows Event Logger. */
	private static Logger logger = Logger.getLogger(Main.class);
	
	/**
	 * This methods prints out the version of the agent.
	 */
	private static void printVersion() {
		System.out.println("SRVMON AGENT for Windows v0.5\nCopyright (C) 2015  Pol Warnimont\nThe SRVMON AGENT comes with ABSOLUTELY NO WARRANTY!");
	}
	
	/**
	 * Main method of the class.
	 * The program will enter in an infinite loop. Every 300*1000 seconds, a
	 * thread will be executed which performs all the service checks. The
	 * check interval can be defined by the user in the config file.
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
		
			BasicConfigurator.configure();
			NTEventLogAppender eventLogAppender = new NTEventLogAppender();
			eventLogAppender.setSource("srvmon-agent"); 
			eventLogAppender.setLayout(new PatternLayout("%m")); 
			eventLogAppender.activateOptions(); 
			logger.addAppender(eventLogAppender);
			
			logger.info("SRVMON AGENT has started.");
			
			File f = new File("agent.properties");
			Properties prop = new Properties();
			
			if (f.exists()) {
				InputStream in = null;
				
				try {
					in = new FileInputStream("agent.properties");
					
					prop.load(in);
					
					_host_id = XMLMngr.getInstance().getHostID(prop.getProperty("agent.hostname"));
					
					logger.info("This agent has the ID " + _host_id + ".");
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				switch (_host_id) {
					case -3:
						logger.warn("An exception has occured on the SQL server!");
						
						break;
						
					case -4:
						logger.warn("A database warning has occured!");
						
						break;
						
					case -5:
						logger.warn("The current host does not exist in the database!");
						
						break;
						
					default:
						//ServiceCheck.executeCheck(null);
						while (true) {
							logger.info("Agent waking up, invoking new worker thread...");
							
							new WorkerThread(_host_id).start();
							
							logger.info("Agent going to sleep...");
							try {
								Thread.sleep(Integer.parseInt(prop.getProperty("agent.interval")) * 1000);
							} catch (NumberFormatException | InterruptedException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
				}
			}
			else {
				logger.warn("The agent.properties file does not exist!");
				logger.info("A sample configuration file has been generated. Please insert your values!");
				
				OutputStream out = null;
				
				try {
					out = new FileOutputStream("agent.properties");
					
					prop.setProperty("director.url", "http://change.me/director/");
					prop.setProperty("agent.interval", "300");
					prop.setProperty("agent.hostname", InetAddress.getLocalHost().getHostName());
					
					prop.store(out, null);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
