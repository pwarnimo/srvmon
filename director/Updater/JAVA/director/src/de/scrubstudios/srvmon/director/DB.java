/*
 * File        : DB.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.0

 * Description : This file is part of the SRVMON director.
 *               This class is used for the database connection.
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

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Logger;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;

public class DB {
	private Connection con;
	private Logger logger;
	
	public DB() {
		logger = Logger.getLogger("SRVMON-DIRECTOR");		
		logger.info("DB> Init DB.class...");
		
		String driver = "org.gjt.mm.mysql.Driver";
		String dburl = "jdbc:mysql://localhost/srvmon";
		
		try {
			Class.forName(driver);
			con = (Connection) DriverManager.getConnection(dburl, "sqlusr", "q1w2e3!");
			logger.info("DB> OK!");
		} 
		catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			logger.warning("DB> Failure in DB.class!");
		}
	}
	
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
