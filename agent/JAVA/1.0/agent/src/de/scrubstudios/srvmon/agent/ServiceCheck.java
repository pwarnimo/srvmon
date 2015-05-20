/*
 * File        : ServiceCheck.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 1.0 R1

 * Description : This file is part of the SRVMON AGENT.
 *               This class defines a service check.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
 *  2015-05-15 : Preparing for v1.0.
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

package de.scrubstudios.srvmon.agent;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.logging.Logger;

/**
 * This class is used for service checks.
 * With the help of this class, the agent is able to execute the 
 * available service check scripts. The scripts are located in the 
 * /usr/share/srvmon/checkscripts directory.
 * @author pwarnimo
 * @version 1.0
 */
public class ServiceCheck {
	/**
	 * This method executes a single service check which is given by
	 * the check parameter. The method creates a new process for the
	 * check script and sets then parses the output of the executed 
	 * check script.
	 * @param check Service check.
	 */
	public static void executeCheck(Service check) {
		Logger _logger = Logger.getLogger("SRVMON-AGENT");
		_logger.info("SVCCHECK> Executing check: " + check);
		
		try {
			Process p = Runtime.getRuntime().exec("/usr/share/srvmon/checkscripts/" + check.getCmd());
			p.waitFor();
			 
		    BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
		 
		    String line = "";			
		    while ((line = reader.readLine())!= null) {
		    	String[] output = line.split(";");
		    	_logger.info("SVCCHECK> Status = " + output[0] + " MSG = " + output[1]);
		    	check.setValue(Integer.parseInt(output[0]));
		    	check.setCheckOutput(output[1]);
		    }
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
		}
	}
}
