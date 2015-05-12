/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.1

 * Description : This file is part of the SRVMON director.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-05 : Created class.
 *  2015-05-07 : Finalized director updater.
 *  2015-05-08 : Added javadoc.
 *  2015-05-12 : Starting v1.1.
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

/** Main class for the SRVMON DIRECTOR - UPDATER.
 *  @author Pol Warnimont
 *  @version 1.0
 */
public class Main {

	/** Main method of the Main class. Enters a while loop and invokes a thread every 300 * 1000 seconds.
	 * @param args Command line arguments. If -v -> return version.
	 */
	public static void main(String[] args) {
		if (args.length > 0) {
			if (args[0].equals("-v")) {
				System.out.println("SRVMON DIRECTOR - UPDATER 1.0");
				System.out.println("Copyright (C) 2015  Pol Warnimont");
				System.out.println("The SRVMON DIRECTOR UPDATER comes with ABSOLUTELY NO WARRANTY!");
			}
		}
		else {
			Logger logger = Logger.getLogger("SRVMON-DIRECTOR");		
			logger.info("Director has started.");
			
			File f = new File("config.properties");
			
			if (f.exists()) {
				logger.info("The file settings.properties exists. Continuing...");
				
				DBng db0 = DBng.getInstance();
				
				/*try {
					while (true) {
						logger.info("Invoking thread...");
						new WorkerThread().start();
						logger.info("Sleeping...");
						Thread.sleep(300 * 1000);
					}
				} catch (InterruptedException e) {
					e.printStackTrace();
				}*/
			}
			else {
				logger.warning("The config.properties file is non existent!");
				logger.info("A sample configuration has been created. Please insert your values!");
				
				Properties prop = new Properties();
				
				try {
					OutputStream out = new FileOutputStream(f.getName());
					
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
