/*
 * File        : WorkerThread.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 0.1

 * Description : This file is part of the SRVMON AGENT.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
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

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.logging.Logger;

public class WorkerThread extends Thread {
	private int _host_id;
	private ArrayList<ServiceCheck> _checks = new ArrayList<>();
	private Logger _logger;
	private XMLMngr _xmlmngr = new XMLMngr();
	
	public WorkerThread() {
		_logger = Logger.getLogger("SRVMON-AGENT");
	}
	
	public void run() {
		_logger.info("WORKER> Thread execution started...");
		
		this._checks = this.getServices();
		this._host_id = this.getHostID();
		
		_logger.info("WORKER> Thread execution finished!");
	}
	
	private ArrayList<ServiceCheck> getServices() {
		_logger.info("WORKER> Getting services...");
		//return _xmlmngr.getServicesFromDirector();
		return null;
	}
	
	private int getHostID() {
		try {
			_logger.info("WORKER> Getting ID for this host (" + InetAddress.getLocalHost().getHostName() + ")");
			
			return _xmlmngr.getHostID(InetAddress.getLocalHost().getHostName());
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		
		return -1;
	}
}
