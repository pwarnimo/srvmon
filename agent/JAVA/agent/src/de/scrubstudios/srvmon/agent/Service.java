/*
 * File        : Service.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.0
 * Description : This file is part of the SRVMON agent.
 *               This class defines a service check.
 *
 * Changelog
 * ---------
 *  2015-05-09 : Created class.
 *  2015-05-11 : Added Javadoc comments.
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

/**
 * This class defines a single service check.
 * @author Pol Warnimont
 * @version 0.1
 */
public class Service {
	/** ID number of the service. */
	private int _id;
	/** Return value of the service check script */
	private int _value;
	/** Command for executing the check script */
	private String _cmd;
	/** Output of the check script */
	private String _checkOutput;
	
	/**
	 * Constructor for the Service class.
	 * Initializes and creates a new service instance.
	 * @param id ID number for the new service.
	 * @param value Check value for the new service (Usually 4).
	 * @param cmd Command for the new service check.
	 * @param checkOutput Output of the new service (Usually "Check Pending!").
	 */
	public Service(int id, int value, String cmd, String checkOutput) {
		this._id = id;
		this._value = value;
		this._cmd = cmd;
		this._checkOutput = checkOutput;
	}
	
	public void setID(int id) {
		this._id = id;
	}
	
	public void setValue(int value) {
		this._value = value;
	}
	
	public void setCmd(String cmd) {
		this._cmd = cmd;
	}
	
	public void setCheckOutput(String checkOutput) {
		this._checkOutput = checkOutput;
	}
	
	public int getID() {
		return this._id; 
	}
	
	public int getValue() {
		return this._value;
	}
	
	public String getCmd() {
		return this._cmd;
	}
	
	public String getCheckOutput() {
		return this._checkOutput;
	}
}
