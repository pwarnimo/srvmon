/*
 * File        : WorkerThread.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 1.0 R1

 * Description : This file is part of the SRVMON AGENT.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
 *  2015-05-15 : Preparing v1.0.
 *	2015-05-20 : Final bugfixing + Adding comments.
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

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Logger;

/**
 * This class defines a worker thread.
 * In this class a thread for a worker is defined. The worker thread is
 * used to get an up to date list of services for this agent from the
 * director server. The worker then proceeds to execute the check scripts
 * for the retrieved services and updates the values accordingly. The 
 * worker thread thread will be periodically invoked from the main class.
 * @author pwarnimo
 * @version 1.0
 */
public class WorkerThread extends Thread {
	/** ID number for the current agent */
	private int _host_id;
	/** Array list for the services */
	private ArrayList<Service> _services = new ArrayList<>();
	private Date date = new Date();
	
	/**
	 * The contructor initializes the message logger and sets the ID
	 * number for the current agent host.
	 * @param host_id ID number of the agent.
	 */
	public WorkerThread(int host_id) {
		System.out.println(new Timestamp(date.getTime()) + " > WORKER: Using agent ID " + _host_id);
		this._host_id = host_id;
	}
	
	/**
	 * This method performs the service checks. The method runs trough
	 * all available service checks which are stored in the _services
	 * array list and the executes the check commands. The output of
     * the check commands are then updated on the director server.
	 */
	public void run() {
		System.out.println(new Timestamp(date.getTime()) + " > WORKER: Thread execution has started...");
		
		_services = XMLMngr.getInstance().getServicesFromDirector(_host_id);
		
		if (_services.size() != 0) {
			for (int i = 0; i < _services.size(); i++) {
				String checksum = XMLMngr.getInstance().getScriptChecksum(_host_id, _services.get(i));
				
				if (ServiceCheck.isValid(_host_id, _services.get(i), checksum)) {
					System.out.println(new Timestamp(date.getTime()) + " > WORKER: Script checksum OK :)");
					ServiceCheck.executeCheck(_services.get(i));
					XMLMngr.getInstance().updateService(_host_id, _services.get(i));
				}
				else {
					System.out.println(new Timestamp(date.getTime()) + " * WORKER: The checkscript has been tampered! Checkscript ignored :(");
				}
			}
		}
		else {
			System.out.println(new Timestamp(date.getTime()) + " * WORKER: No services defined for this host!");
		}
		
		System.out.println(new Timestamp(date.getTime()) + " > WORKER: Thread execution has finished.");
	}
}
