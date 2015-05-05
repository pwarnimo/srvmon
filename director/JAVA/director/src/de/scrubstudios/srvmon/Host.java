/*
 * File        : Host.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.0

 * Description : This file is part of the SRVMON director.
 *               This class defines a host.
 *
 * Changelog
 * ---------
 *  2015-05-05 : Created class.
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

package de.scrubstudios.srvmon;

import java.util.logging.Logger;

public class Host {
	private int id;
	private String hostname;
	private String ipaddress;
	private boolean enabled;
	
	private Logger logger;
	
	public Host(int id, String hostname, String ipaddress, boolean enabled) {
		logger = Logger.getLogger("SRVMON-DIRECTOR");		
		logger.info("HOST> Init Host.class...");
		
		this.id = id;
		this.hostname = hostname;
		this.ipaddress = ipaddress;
		this.enabled = enabled;
		
		logger.info("HOST> New Host " + this.hostname + ", OK!");
	}
	
	public void setID(int id) {
		this.id = id;
	}
	
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	
	public void setIPAddress(String ipaddress) {
		this.ipaddress = ipaddress;
	}
	
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	
	public int getID() {
		return id;
	}
	
	public String getHostname() {
		return hostname;
	}
	
	public String getIPAddress() {
		return ipaddress;
	}
	
	public boolean getEnabled() {
		return enabled;
	}
	
	public String toString() {
		return id + ":" + hostname + ":" + ipaddress + ":" + enabled;
	}
}
