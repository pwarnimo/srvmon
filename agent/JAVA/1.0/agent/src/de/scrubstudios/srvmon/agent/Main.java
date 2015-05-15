/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.0
 * Description : This file is part of the SRVMON agent.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-09 : Created class.
 *  2015-05-11 : Added test functions.
 *               Added Javadoc.
 *  2015-05-15 : Preparing agent 1.0.
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
import java.util.Properties;
import java.util.logging.Logger;

import de.scrubstudios.srvmon.agent.WorkerThread;

/** 
 * Main class for the SRVMON AGENT.
 * @author Pol Warnimont
 * @version 1.0
 */
public class Main {
	private static int _host_id = 0;
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
				System.out.println("SRVMON AGENT 0.5");
				System.out.println("Copyright (C) 2015  Pol Warnimont");
				System.out.println("The SRVMON AGENT comes with ABSOLUTELY NO WARRANTY!");
			}
		}
		else {
			Logger logger = Logger.getLogger("SRVMON-AGENT");		
			logger.info("Agent has started.");
			
			File f = new File("config.properties");
			
			Properties prop = new Properties();
			
			if (f.exists()) {
				_host_id = XMLMngr.getInstance().getHostID("debvm");
				
				InputStream in = null;
				try {
					in = new FileInputStream(f.getName());
					
					prop.load(in);
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				
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
					}
				}
			}
			else {
				logger.warning("The config.properties file is non existent!");
				logger.info("A sample configuration has been created. Please insert your values!");
				
				OutputStream out = null;
				
				try {
					out = new FileOutputStream(f.getName());

					prop.setProperty("director.url", "http://127.0.0.1/srvmon-server/");
					prop.setProperty("agent.interval", "300");
					
					prop.store(out, null);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
