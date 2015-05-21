/*
 * File        : SQLTypeEnum.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-13
 * Version     : 1.1 R1

 * Description : This file is part of the SRVMON director.
 *               Enum definition for SQL data types.
 *
 * Changelog
 * ---------
 *  2015-05-13 : Created class.
 *  2015-05-20 : Final bugfixing + Adding comments.
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

package de.scrubstudios.srvmon.director;

/**
 * Enum definition for SQL data types.
 * This enumerator defines the available data types for the SQL database.
 * The enumerator in the QueryParam class. This ensures that the right
 * data types are used when preparing the query.
 * @author Pol Warnimont
 * @version 1.1
 */
public enum SQLTypeEnum {
	/** Integer data type.*/
	INT, 
	/** String data type. */
	STR, 
	/** Boolean data type. */
	BOOL
}
