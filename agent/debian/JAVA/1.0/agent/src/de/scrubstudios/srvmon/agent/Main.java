/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.0 R1
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

package de.scrubstudios.srvmon.agent;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.util.Properties;
import java.util.logging.Logger;

import de.scrubstudios.srvmon.agent.WorkerThread;

/** 
 * Main class for the SRVMON AGENT.
 * @author Pol Warnimont
 * @version 1.0
 */
public class Main {
	/** Host ID for the current agent. */
	private static int _host_id = 0;
	
	/**
	 * This method prints out the version of the agent.
	 */
	private static void printVersion() {
		System.out.println("SRVMON AGENT 1.0 R1\nCopyright (C) 2015  Pol Warnimont\nThe SRVMON AGENT comes with ABSOLUTELY NO WARRANTY!");
	}
	
	/**
	 * Main method of the class.
	 * The program will enter in an endless loop. Every 300*1000 seconds, a 
	 * thread will be executed which will perform the service checks. The
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
			
			Logger logger = Logger.getLogger("SRVMON-AGENT");		
			logger.info("MAIN> Agent has started.");
			
			File f = new File("/etc/srvmon/agent.properties");
			
			Properties prop = new Properties();
			
			if (f.exists()) {	
				InputStream in = null;
				try {
					in = new FileInputStream("/etc/srvmon/agent.properties");
					
					prop.load(in);
					
					_host_id = XMLMngr.getInstance().getHostID(prop.getProperty("agent.hostname"));
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				
				switch (_host_id) {
					case -3:
						logger.warning("MAIN> An exception has occured on the SQL server!");
						
						break;
					case -4:
						logger.warning("MAIN> A database warning has occured!");
						
						break;
					case -5:
						logger.warning("MAIN> The current host does not exists in the database!");
						
						break;
						
					default:
						logger.info("MAIN> Using the SRVMON DIRECTOR SERVER with the URL: " + prop.getProperty("director.url"));
						logger.info("MAIN> The check interval has been set to " + prop.getProperty("agent.interval") + " seconds.");
						
						while (true) {
							logger.info("MAIN> Invoking thread...");
							new WorkerThread(_host_id).start();
							logger.info("MAIN> Sleeping...");
							try {
								Thread.sleep(Integer.parseInt(prop.getProperty("agent.interval")) * 1000);
							} catch (InterruptedException e) {
								e.printStackTrace();
								break;
							}
						}
						
						break;
				}
			}
			else {
				logger.warning("The config.properties file is non existent!");
				logger.info("A sample configuration has been created. Please insert your values!");
				
				OutputStream out = null;
				
				try {
					out = new FileOutputStream("/etc/srvmon/agent.properties");

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
