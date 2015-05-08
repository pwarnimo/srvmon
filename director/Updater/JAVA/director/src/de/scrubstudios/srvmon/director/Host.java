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
 *  2015-05-07 : Finalized director updater.
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

import java.util.logging.Logger;

/** Host class for the SRVMON DIRECTOR - UPDATER. Defines a single host. This class is used in an alrraylist.
 *  @author Pol Warnimont
 *  @version 1.0
 */
public class Host {
	/** Internal ID number. */
	private int id;
	/** Hostname of the host. Usually not the FQDN. */
	private String hostname;
	/** IP address of the host. */
	private String ipaddress;
	/** Online status of the host. True = ONLINE and false = OFFLINE. */
	private boolean enabled;
	/** Logger for messages. */
	private Logger logger;
	
	/** Constructor for a host.
	 * @param id Internal ID number.
	 * @param hostname Name of the new host.
	 * @param ipaddress IP address for the new host.
	 * @param enabled Online status.
	 */
	public Host(int id, String hostname, String ipaddress, boolean enabled) {
		logger = Logger.getLogger("SRVMON-DIRECTOR");		
		logger.info("HOST> Init Host.class...");
		
		this.id = id;
		this.hostname = hostname;
		this.ipaddress = ipaddress;
		this.enabled = enabled;
		
		logger.info("HOST> New Host " + this.hostname + ", OK!");
	}
	
	/** Setter for the internal ID number.
	 * @param id Internal ID number.
	 */
	public void setID(int id) {
		this.id = id;
	}
	
	/** Setter for the hostname.
	 * @param hostname Hostname of the host.
	 */
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	
	/** Setter for the IP address.
	 * @param ipaddress IP address of the host.
	 */
	public void setIPAddress(String ipaddress) {
		this.ipaddress = ipaddress;
	}
	
	/** Setter for the online status.
	 * @param enabled Online status of the host.
	 */
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	
	/** Getter for the internal host ID number.
	 * @return Host ID number.
	 */
	public int getID() {
		return id;
	}
	
	/** Getter for the name of a host.
	 * @return Hostname of the host.
	 */
	public String getHostname() {
		return hostname;
	}
	
	/** Getter for the IP address of a host.
	 * @return The IP address of the host.
	 */
	public String getIPAddress() {
		return ipaddress;
	}
	
	/** Getter for the online status of a host.
	 * @return Online status of the host.
	 */
	public boolean getEnabled() {
		return enabled;
	}
	
	/** Returns a formatted string of the data for a host.
	 * @return Formatted string of the host data.
	 */
	public String toString() {
		return id + ":" + hostname + ":" + ipaddress + ":" + enabled;
	}
}
