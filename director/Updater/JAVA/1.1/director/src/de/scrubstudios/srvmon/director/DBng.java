/*
 * File        : DBng.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-12
 * Version     : 1.1

 * Description : This file is part of the SRVMON director.
 *               This class is used for the database connection.
 *
 * Changelog
 * ---------
 *  2015-05-12 : Created class.
 *  2015-05-13 : Modified query() method.
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
import java.io.IOException;
import java.io.InputStream;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;

/**
 * Database wrapper class.
 * This class is used to establish a connection with a database. Please
 * note that this class uses the mysql-connector-java which is located
 * in the lib folder. This class uses the singleton pattern so that
 * only one instance of this class is created. This has the advantage
 * of preventing the creation of unnecessary database connections.
 * @author pwarnimo
 * @version 1.1
 */
public class DBng {
	/** Instance of the class itself. */
	private static DBng _instance;
	/** MySQL connection handle. */
	private Connection _connection;
	/** Result set of a query. */
	private ResultSet _result;
	/** Query execution status. */
	private boolean _error;
	
	/**
	 * Constructor for the DBng class.
	 * The constructor initializes the database connection stored in
	 * _connection. The database connection properties for the server
	 * are loaded from the config.properties file. A sample properties
	 * file will be created in the Main class if the file does not exist.
	 */
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
	
	/**
	 * This method checks if there is already an instance of this class.
	 * If no instance exists, a new instance will be created. If no there
	 * is already an instance, the method will return that instance.
	 * @return Instance of this class stored in _instance.
	 */
	public static DBng getInstance() {
		if (_instance == null) {
			_instance = new DBng();
		}
		
		return _instance;
	}
	
	/**
	 * This method is used to perform a query on the database server. The
	 * method builds a prepared statement by using the parameters stored
	 * in the params arraylist. The query is then executed and the 
	 * result set will be stored in the _result variable. If _error
	 * variable will be set if the query encounters an error. The params
	 * arraylist can be set to null if the query doesn't use any 
	 * parameters.
	 * @param sql SQL query statement.
	 * @param params Parameters for the SQL statement.
	 * @return An instance of itself.
	 */
	public DBng query(String sql, ArrayList<QueryParam> params) {
		this._error = false;
		
		try {
			if (params != null) {
				PreparedStatement stmt = (PreparedStatement)_connection.prepareStatement(sql);
				
				for (int i = 0; i < params.size(); i++) {
					switch (params.get(i).getType()) {
						case INT:
							stmt.setInt(i + 1, Integer.parseInt(params.get(i).getValue()));
							
							break;
							
						case STR:
							stmt.setString(i + 1, params.get(i).getValue());
							
							break;
							
						case BOOL:
							stmt.setBoolean(i + 1, Boolean.parseBoolean(params.get(i).getValue()));
							
							break;
					}
				}
				
				if (stmt.execute()) {
					this._result = stmt.getResultSet();
				}
				else {
					this._error = true;
				}
			}
			else {
				Statement stmt = (Statement)this._connection.createStatement();
				this._result = stmt.executeQuery(sql);
			}
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return this;
	}
	
	/**
	 * This method returns the query execution status.
	 * @return The execution status of the query.
	 */
	public boolean error() {
		return this._error;
	}
	
	/**
	 * This method is used to get the result set of the executed query.
	 * @return The result set of the executed query.
	 */
	public ResultSet result() {
		return this._result;
	}
}
