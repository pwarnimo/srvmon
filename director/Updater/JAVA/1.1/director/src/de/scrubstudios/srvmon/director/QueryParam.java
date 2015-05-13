/*
 * File        : QueryParam.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-12
 * Version     : 1.1
 *
 * Description : This file is part of the SRVMON director.
 *               This class defines parameters for a DB query.
 *
 * Changelog
 * ---------
 *  2015-05-13 : Created class.
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

/**
 * Query parameter definition class
 * This class is only used in the DBng class. With the help of this
 * class, the query() method of the DBng class knows which type of
 * parameter should be bound to the query. The parameter types are
 * defined in an enum.
 * @author pwarnimo
 * @version 1.1
 */
public class QueryParam {
	/** Parameter value. */
	private String _value;
	/** Parameter type. */
	private SQLTypeEnum _type;
	
	/**
	 * Constructor for the new parameter.
	 * @param type Type of the new parameter.
	 * @param value Value for the new parameter.
	 */
	public QueryParam(SQLTypeEnum type, String value) {
		this._type = type;
		this._value = value;
	}
	
	/**
	 * Sets the type for the parameter.
	 * @param type New type for the parameter.
	 */
	public void setType(SQLTypeEnum type) {
		this._type = type;
	}
	
	/**
	 * Sets the value for the parameter.
	 * @param value New value for the parameter.
	 */
	public void setValue(String value) {
		this._value = value;
	}
	
	/**
	 * Gets the type of the parameter.
	 * @return Type of the parameter.
	 */
	public SQLTypeEnum getType() {
		return this._type;
	}
	
	/**
	 * Gets the value for the parameter.
	 * @return Value of the parameter.
	 */
	public String getValue() {
		return this._value;
	}
}
