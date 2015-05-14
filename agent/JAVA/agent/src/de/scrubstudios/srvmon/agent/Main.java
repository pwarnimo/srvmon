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

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Logger;

/** 
 * Main class for the SRVMON AGENT.
 * @author Pol Warnimont
 * @version 0.1
 */
public class Main {
	/**
	 * Main method of the class.
	 * The program will enter in an endless loop. Every 300*1000 seconds, a 
	 * thread will be executed which will perform the service checks.
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
			
			if (f.exists()) {
				ArrayList<Service> services = new ArrayList<>();
				
				XMLMngr xml0 = XMLMngr.getInstance();
				
				services = xml0.getServicesFromDirector(23);
				
				for (int i = 0; i < services.size(); i++) {
					ServiceCheck.executeCheck(services.get(i));
					System.out.println("New Output = " + services.get(i).getCheckOutput() + " -- " + services.get(i).getValue());
					xml0.updateService(23, services.get(i));
				}
			}
			else {
				logger.warning("The config.properties file is non existent!");
				logger.info("A sample configuration has been created. Please insert your values!");
				
				Properties prop = new Properties();
				
				try {
					OutputStream out = new FileOutputStream(f.getName());
					
					prop.setProperty("agent.id", "23");
					prop.setProperty("director.url", "http://127.0.0.1/srvmon-server/");
					
					prop.store(out, null);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
