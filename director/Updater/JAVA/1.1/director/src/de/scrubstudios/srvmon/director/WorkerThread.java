/*
 * File        : WorkerThread.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.1 R1

 * Description : This file is part of the SRVMON director.
 *               This class implements a worker thread which checks all 
 *               hosts for their status. The thread is executed on a user 
 *               defined interval.
 *
 * Changelog
 * ---------
 *  2015-05-05 : Created class.
 *  2015-05-07 : Finalized director updater.
 *  2015-05-12 : Starting v1.1.
 *  2015-05-13 : Modified run() method to use new DBng class.
 *  2015-05-20 : Final bugfixing + Adding comments.
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

import java.io.IOException;
import java.net.InetAddress;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Logger;

/** Worker thread class.
 * This class defines a so called "worker thread". A worker thread is
 * used to check all available hosts in the database for their online
 * status. The worker thread fetches a list of hosts and then checks
 * if the host is reachable by using the java method
 * InetAddress.getByName().isReachable(). The updated status for the
 * hosts is then written to the database. The worker thread will be
 * called periodically from the Main class.
 * @author Pol Warnimont
 * @version 1.1
 */
public class WorkerThread extends Thread {
	/** Message logger. */
	private Logger _logger;
	
	/** 
	 * Constructor for the worked thread. 
	 * The constructor will initialize the logger for this class.
	 */
	public WorkerThread() {
		_logger = Logger.getLogger("SRVMON-DIRECTOR");
	}
	
	/** 
	 * This method defines the thread which is called in the main 
	 * class. The run() method will be periodically called and the 
	 * host status is then determined and updated.
	 */
	public void run() {
		_logger.info("WORKER> Executing thread...");
		
		DBng db0 = DBng.getInstance();
		
		if (db0.query("CALL getServer(-1, TRUE, @err)", null).error() == false) {
			try {
				ResultSet res = db0.result();
				
				while (res.next()) {
					if (InetAddress.getByName(res.getString("dtIPAddress")).isReachable(2000)) {
						_logger.info("WORKER> " + res.getString("dtHostname") + " (" + res.getString("dtIPAddress") + ") is reachable.");
						
						ArrayList<QueryParam> params = new ArrayList<>();
						
						params.add(new QueryParam(SQLTypeEnum.INT, String.valueOf(res.getInt("idServer"))));
						
						db0.query("CALL setSystemStatus(?, TRUE, @err)", params);
					}
					else {
						_logger.warning("WORKER> " + res.getString("dtHostname") + " (" + res.getString("dtIPAddress") + ") is unreachable!");
						
						ArrayList<QueryParam> params = new ArrayList<>();
						
						params.add(new QueryParam(SQLTypeEnum.INT, String.valueOf(res.getInt("idServer"))));
						
						db0.query("CALL setSystemStatus(?, FALSE, @err)", params);
						db0.query("CALL disableChildrenChecks(?,@err)", params);
					}
				}
			} catch (SQLException | IOException e) {
				e.printStackTrace();
			}
		}
		else {
			_logger.warning("WORKER> A database error has occured!");
		}
		
		_logger.info("WORKER> Thread execution finished.");
	}
}
