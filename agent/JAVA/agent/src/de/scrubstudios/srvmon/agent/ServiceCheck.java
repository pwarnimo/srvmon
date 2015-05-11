/*
 * File        : ServiceCheck.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 0.1

 * Description : This file is part of the SRVMON AGENT.
 *               This class defines a service check.
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

public class ServiceCheck {
	private int _id;
	private String _caption;
	private String _description;
	private String _check_command;
	
	public ServiceCheck(int id, String caption, String description, String check_command) {
		this._id = id;
		this._caption = caption;
		this._description = description;
		this._check_command = check_command;
	}
	
	public void setID(int id) {
		this._id = id;
	}
	
	public int getID() {
		return this._id;
	}
	
	public void setCaption(String caption) {
		this._caption = caption;
	}
	
	public String getCaption() {
		return this._caption;
	}
	
	public void setDescription(String description) {
		this._description = description;
	}
	
	public String getDescription() {
		return this._description;
	}
	
	public void setCheckCommand(String check_command) {
		this._check_command = check_command;
	}
	
	public String getCheckCommand() {
		return this._check_command;
	}
	
	public String toString() {
		return _id + ":" + _caption + ":" + _description + ":" + _check_command;
	}
}
