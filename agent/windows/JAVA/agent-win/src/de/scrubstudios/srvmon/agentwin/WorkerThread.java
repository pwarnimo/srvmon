/*
 * File        : WorkerThread.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-07-03
 * Version     : 0.5
 * Description : This file is part of the SRVMON AGENT.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-07-03 : Created class.
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

package de.scrubstudios.srvmon.agentwin;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.nt.NTEventLogAppender;

public class WorkerThread extends Thread {
	private int _host_id;
	private ArrayList<Service> _services = new ArrayList<>();
	private static Logger _logger = Logger.getLogger(WorkerThread.class);
	
	public WorkerThread(int host_id) {
		NTEventLogAppender eventLogAppender = new NTEventLogAppender();
		eventLogAppender.setSource("srvmon-agent"); 
		eventLogAppender.setLayout(new PatternLayout("%m")); 
		eventLogAppender.activateOptions(); 
		_logger.addAppender(eventLogAppender);
		
		this._host_id = host_id;
	}
	
	public void run() {
		_logger.info("Thread execution has started...");
		
		_services = XMLMngr.getInstance().getServicesFromDirector(_host_id);
		
		if (_services.size() != 0) {
			for (int i = 0; i < _services.size(); i++) {
				_logger.info("Checking SID=" + _services.get(i).getID() + " -> " + _services.get(i).getCmd());
				ServiceCheck.executeCheck(_services.get(i));
				_logger.info("Updating SID=" + _services.get(i).getID() + " -> O=" + _services.get(i).getValue() + " M=" + _services.get(i).getCheckOutput());
				XMLMngr.getInstance().updateService(_host_id, _services.get(i));
			}
		}
		else {
			_logger.warn("No services defined for this host!");
		}
		
		_logger.info("Thread execution has finished!");
	}
}