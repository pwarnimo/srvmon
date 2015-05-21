/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.1 R1

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
 *  
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

package de.scrubstudios.srvmon.director;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Properties;
import java.util.logging.Logger;

/**
 * Main class for the SRVMON DIRECTOR - UPDATER.
 * @author Pol Warnimont
 * @version 1.1
 */
public class Main {
	/**
	 * This method prints out the current version of the application.
	 */
	private static void printVersion() {
		System.out.println("SRVMON DIRECTOR - UPDATER V1.1 R1\nCopyright (C)  Pol Warnimont\nThe SRVMON DIRECTOR UPDATER comes with ABSOLUTELY NO WARRANTY!");
	}
	
	/**
	 * The main method enters a while loop which will run until the
	 * program execution is canceled. Inside the loop, a new worker
	 * thread will be created every 5 minutes (300*1000s). If the
	 * method is unable to find the properties file, a sample file
	 * will be generated and the program exits.The user then has to
	 * set the appropriate values inside the file.
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
			
			Logger logger = Logger.getLogger("SRVMON-DIRECTOR");		
			logger.info("Updater v1.1 has started.");
			
			File f = new File("/etc/srvmon/director.properties");
			
			if (f.exists()) {
				logger.info("The file director.properties exists. Continuing...");
				
				try {
					while (true) {
						logger.info("Invoking thread...");
						new WorkerThread().start();
						logger.info("Sleeping...");
						Thread.sleep(300 * 1000);
					}
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
			else {
				logger.warning("The director.properties file is non existent!");
				logger.info("A sample configuration has been created. Please insert your values!");
				
				Properties prop = new Properties();
				
				try {
					OutputStream out = new FileOutputStream("/etc/srvmon/director.properties");
					
					prop.setProperty("db.hostname", "127.0.0.1");
					prop.setProperty("db.username", "username");
					prop.setProperty("db.password", "P@ssw0rD!");
					prop.setProperty("db.name", "dbname");
					
					prop.store(out, null);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
