/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.1 R1
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
 *  2015-07-08 : Adding encryption capabilities.
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
import java.sql.Timestamp;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Logger;

import de.scrubstudios.srvmon.agent.WorkerThread;

/** 
 * Main class for the SRVMON AGENT.
 * @author Pol Warnimont
 * @version 1.1
 */
public class Main {
	/** Host ID for the current agent. */
	private static int hostid = 0;
	private static Date date = new Date();
	
	/**
	 * This method prints out the version of the agent.
	 */
	private static void printVersion() {
		System.out.println("SRVMON AGENT 1.1 for Debian GNU/Linux\nCopyright (C) 2015  Pol Warnimont\nThe SRVMON AGENT comes with ABSOLUTELY NO WARRANTY!");
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
			
			System.out.println(new Timestamp(date.getTime()) + " > AGENT is initializing...");
			
			File f = new File("agent.properties");
			
			Properties prop = new Properties();
			
			if (f.exists()) {	
				InputStream in = null;
				try {
					in = new FileInputStream("agent.properties");
					
					prop.load(in);
					
					hostid = XMLMngr.getInstance().getHostID(prop.getProperty("agent.hostname"));
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				
				switch (hostid) {
					case -3:
						System.out.println(new Timestamp(date.getTime()) + " * An exception has occured on the SQL server!");
						
						break;
					case -4:
						System.out.println(new Timestamp(date.getTime()) + " * A database warning has occured!");
						
						break;
					case -5:
						System.out.println(new Timestamp(date.getTime()) + " * The current host does not exist in the database!");
						
						break;
						
					default:
						System.out.println(new Timestamp(date.getTime()) + " > Using the DIRECTOR SERVER \"" + prop.getProperty("director.url") + "\" for the Agent ID " + hostid + ".");
						System.out.println(new Timestamp(date.getTime()) + " > The check interval has been set to " + prop.getProperty("agent.interval") + " seconds.");
						
						while (true) {
							System.out.println(new Timestamp(date.getTime()) + " > Waking up, calling new worker thread...");
							new WorkerThread(hostid).start();
							System.out.println(new Timestamp(date.getTime()) + " > Sleeping...");
							try {
								Thread.sleep(Integer.parseInt(prop.getProperty("agent.interval")) * 1000);
							} catch (InterruptedException e) {
								e.printStackTrace();
								break;
							}
						}
				}
			}
			else {
				System.out.println(new Timestamp(date.getTime()) + " * The agent.properties file does not exist!");
				System.out.println(new Timestamp(date.getTime()) + " * A sample configuration file has been generated. Please insert your values!");
				
				OutputStream out = null;
				
				try {
					out = new FileOutputStream("agent.properties");

					prop.setProperty("director.url", "http://change.me/director/");
					prop.setProperty("agent.interval", "300");
					prop.setProperty("agent.username", "agentusr");
					prop.setProperty("agent.password", "agent1.2.3");
					prop.setProperty("agent.enckey", "89u43frä-ü420q");
					prop.setProperty("agent.hostname", InetAddress.getLocalHost().getHostName());
					
					prop.store(out, null);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
