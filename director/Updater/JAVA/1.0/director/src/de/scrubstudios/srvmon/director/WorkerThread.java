/*
 * File        : WorkerThread.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.0

 * Description : This file is part of the SRVMON director.
 *               This class implements a worker thread which checks all 
 *               hosts for their status. The thread is executed on a user 
 *               defined interval.
 *
 * Changelog
 * ---------
 *  2015-05-05 : Created class.
 *  2015-05-07 : Finalized director updater.
 *  2015-05-12 : Added support for Java properties.
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

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Properties;
import java.util.logging.Logger;

/** Worker thread class for the SRVMON DIRECTOR - UPDATER. A worker thread. This class is called in the main class.
 *  @author Pol Warnimont
 *  @version 1.0
 */
public class WorkerThread extends Thread {
	/** Arraylist containing the list of hosts. */
	private ArrayList<Host> arrHosts;
	/** Database instance. */
	private DB db0;
	/** Message logger. */
	private Logger logger;
	
	/** Constructor for the worked thread. Initializes the logger.
	 * 
	 */
	public WorkerThread() {
		logger = Logger.getLogger("SRVMON-DIRECTOR");
		
		try {
			InputStream in = new FileInputStream("config.properties");
			Properties prop = new Properties();
			
			prop.load(in);
			
			db0 = new DB(prop.getProperty("db.hostname"), prop.getProperty("db.name"), prop.getProperty("db.username"), prop.getProperty("db.password"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/** This method defines the thread which is called in the main class. The run() method will be periodically called and the host status is then determined and updated.
	 * 
	 */
	public void run() {
		logger.info("WORKER> Executing thread...");
		
		//db0 = new DB();
		arrHosts = db0.getHostsFromDB();
		
		Iterator<Host> it_hosts = arrHosts.iterator();
		
		while (it_hosts.hasNext()) {
			Host tmpHost = it_hosts.next();
			try {
				if (InetAddress.getByName(tmpHost.getIPAddress()).isReachable(2000)) {
					logger.info("WORKER> Host " + tmpHost.getHostname() + " is UP.");
					db0.setHostStatus(tmpHost.getID(), true);
				}
				else {
					logger.info("WORKER> Host " + tmpHost.getHostname() + " is DOWN.");
					db0.setHostStatus(tmpHost.getID(), false);
					db0.disableChildrenForHost(tmpHost.getID());
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		logger.info("WORKER> Thread execution finished.");
	}
}
