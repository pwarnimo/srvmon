/*
 * File        : DBng.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.1

 * Description : This file is part of the SRVMON director.
 *               This class is used for the database connection.
 *
 * Changelog
 * ---------
 *  2015-05-05 : Created class.
 *  2015-05-07 : Finalized director updater.
 *  2015-05-08 : Added javadoc.
 *  2015-05-12 : Starting v1.1.
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

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Logger;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;

public class DBng {
	private static DBng _instance;
	private Connection _connection;
	
	private DBng() {
		try {
			InputStream in = new FileInputStream("config.properties");
			Properties prop = new Properties();
			
			prop.load(in);
			
			String driver = "org.gjt.mm.mysql.Driver";
			String dburl = "jdbc:mysql://" + prop.getProperty("db.hostname") + "/" + prop.getProperty("db.name");
			
			Class.forName(driver);
			_connection = (Connection)DriverManager.getConnection(dburl, prop.getProperty("db.username"), prop.getProperty("db.password"));
		} catch (ClassNotFoundException | SQLException | IOException e) {
			e.printStackTrace();
		}
	}
	
	public static DBng getInstance() {
		if (_instance == null) {
			_instance = new DBng();
		}
		
		return _instance;
	}
}
