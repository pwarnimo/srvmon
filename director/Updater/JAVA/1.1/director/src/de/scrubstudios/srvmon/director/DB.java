/*
 * File        : DB.java
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

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Logger;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;

/** Database class for the SRVMON DIRECTOR - UPDATER. Contains all database functions which are needed for the updater.
 *  @author Pol Warnimont
 *  @version 1.0
 */
public class DB {
	/** Database handle. */
	private Connection con;
	/** Message logger. */
	private Logger logger;
	/** Database host */
	private String dbhost;
	/** Database name */
	private String dbname;
	/** Database username */
	private String dbusername;
	/** Database password */
	private String dbpassword;
	
	/**
	 * Constructor for the DB class. Sets up the database connection.
	 * @param dbhost Hostname of the database server.
	 * @param dbname Database name on the database server.
	 * @param dbusername Username for the database server.
	 * @param dbpassword Password for the database user.
	 */
	public DB(String dbhost, String dbname, String dbusername, String dbpassword) {
		logger = Logger.getLogger("SRVMON-DIRECTOR");		
		logger.info("DB> Init DB.class...");
		
		this.dbhost = dbhost;
		this.dbname = dbname;
		this.dbusername = dbusername;
		this.dbpassword = dbpassword;
		
		String driver = "org.gjt.mm.mysql.Driver";
		String dburl = "jdbc:mysql://" + this.dbhost + "/" + this.dbname;
		
		try {
			Class.forName(driver);
			con = (Connection) DriverManager.getConnection(dburl, this.dbusername, this.dbpassword);
			logger.info("DB> OK!");
		} 
		catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			logger.warning("DB> Failure in DB.class!");
		}
	}
	
	/** This method is needed to retrieve a list of all the available hosts from the database.
	 * @return Returns an arraylist with all the available hosts.
	 */
	public ArrayList<Host> getHostsFromDB() {
		ArrayList<Host> arrHosts = new ArrayList<>();
		Statement stmt;
		ResultSet res;		
		String qry = "CALL getServer(-1,FALSE,@err)";
		
		logger.info("DB> Executing statement : CALL getServer(-1,FALSE,@err)");
		
		try {
			stmt = (Statement) con.createStatement();
			res = stmt.executeQuery(qry);
			
			logger.info("DB> Fetching results...");
			
			while (res.next()) {
				arrHosts.add(new Host(res.getInt("idServer"),
						res.getString("dtHostname"),
						res.getString("dtIPAddress"),
						res.getBoolean("dtEnabled")));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.warning("DB> DB.class has failed!");
		}
		
		logger.info("DB> OK, got " + arrHosts.size() + " hosts.");
		
		return arrHosts;
	}
	
	/** This method can set the online status of a host.
	 * @param id Internal ID number of the host.
	 * @param status New status for the host. False = OFFLINE and TRUE = ONLINE.
	 */
	public void setHostStatus(int id, boolean status) {
		PreparedStatement stmt;
		String qry = "CALL setSystemStatus(?,?,@err)";
		
		logger.info("DB> Setting status for ID=" + id + " to " + status);
		
		try {
			stmt = (PreparedStatement) con.prepareStatement(qry);
			
			stmt.setInt(1, id);
			stmt.setBoolean(2, status);
			stmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.warning("DB> DB.class has failed!");
		}
		
		logger.info("DB> Query OK!");
	}
	
	/** This method disables all children hosts of the given parent host. The service checks are also set to UNREACHABLE.
	 * @param id Internal ID number of the parent host.
	 */
	public void disableChildrenForHost(int id) {
		PreparedStatement stmt;
		String qry = "CALL disableChildrenChecks(?,@err)";
		
		logger.info("DB> Disabling children checks for ID=" + id);
		
		try {
			stmt = (PreparedStatement) con.prepareStatement(qry);
			
			stmt.setInt(1, id);
			stmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.info("DB> DB.class has failed!");
		}
		
		logger.info("DB> Query OK!");
	}
}
