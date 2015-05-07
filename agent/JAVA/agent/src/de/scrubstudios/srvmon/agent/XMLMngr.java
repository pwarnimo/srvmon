/*
 * File        : XMLMngr.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 0.1

 * Description : This file is part of the SRVMON AGENT.
 *               This class is used to generate XML data.
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

import java.util.ArrayList;
import java.util.logging.Logger;

public class XMLMngr {
	private Logger _logger;
	
	public XMLMngr() {
		_logger = Logger.getLogger("SRVMON-AGENT");
	}
	
	public ArrayList<ServiceCheck> getServicesFromDirector() {
		_logger.info("XMLMNGR> Sending XML request to director...");
		
		return null;
	}
	
	public int getHostID(String hostname) {
		_logger.info("XMLMNGR> Sending XML request to director...");
		
		return 0;
	}
}
