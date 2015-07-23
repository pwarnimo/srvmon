/*
 * File        : DB.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-12
 * Version     : 1.2 P1
 * Description : This file is part of the SRVMON director.
 *               This class is used for the database connection.
 *
 * Changelog
 * ---------
 *  2015-05-12 : Created class.
 *  2015-05-13 : Modified query() method.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-23 : Preparing for package release.
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

package de.scrubstudios.srvmon.director.updater.classes;

import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database wrapper class.
 * This class is used to establish a connection with a database. Please note 
 * that this class uses the mysql-connector-java which is located in the lib 
 * folder. This class uses the singleton pattern so that only one instance of 
 * this class is created. This has the advantage of preventing the creation of 
 * unnecessary database connections.
 * @author Pol Warnimont
 * @version 1.2
 */
public class DB {
    /** Instance of the class itself. */
    private static DB instance;
    /** MySQL connection handle. */
    private Connection connection;
    /** Result set of a query. */
    private ResultSet result;
    /** Query execution status. */
    private boolean error;
	
    /**
     * Constructor for the DB class.
     * The constructor initializes the database connection stored in connection.
     * The database connection properties for the server are loaded from the 
     * config.properties file. A sample properties file will be created in the 
     * Main class if the file does not exist.
     */
    private DB() {
        try {
            InputStream in = new FileInputStream("/etc/srvmon/director.properties");
            Properties prop = new Properties();

            prop.load(in);

            String driver = "org.gjt.mm.mysql.Driver";
            String dburl = "jdbc:mysql://" + prop.getProperty("db.hostname") + "/" + prop.getProperty("db.name");

            Class.forName(driver);
            connection = (Connection)DriverManager.getConnection(dburl, prop.getProperty("db.username"), prop.getProperty("db.password"));
        } catch (ClassNotFoundException | SQLException | IOException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
	
    /**
     * This method checks if there is already an instance of this class. If no 
     * instance exists, a new instance will be created. If no there is already 
     * an instance, the method will return that instance.
     * @return Instance of this class stored in _instance.
     */
    public static DB getInstance() {
        if (instance == null) {
            instance = new DB();
        }

        return instance;
    }
	
    /**
     * This method is used to perform a query on the database server. The method
     * builds a prepared statement by using the parameters stored in the params 
     * arraylist. The query is then executed and the result set will be stored 
     * in the _result variable. If _error variable will be set if the query 
     * encounters an error. The params arraylist can be set to null if the query
     * doesn't use any parameters.
     * @param sql SQL query statement.
     * @param params Parameters for the SQL statement.
     * @return An instance of itself.
     */
    public DB query(String sql, ArrayList<QueryParam> params) {
        this.error = false;

        try {
            if (params != null) {
                PreparedStatement stmt = (PreparedStatement)connection.prepareStatement(sql);

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
                        this.result = stmt.getResultSet();
                    }
                    else {
                        this.error = true;
                }
            }
            else {
                Statement stmt = (Statement)this.connection.createStatement();
                this.result = stmt.executeQuery(sql);
            }
        } 
        catch (SQLException ex) {
            Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
        }

        return this;
    }
	
    /**
     * This method returns the query execution status.
     * @return The execution status of the query.
     */
    public boolean error() {
            return this.error;
    }

    /**
     * This method is used to get the result set of the executed query.
     * @return The result set of the executed query.
     */
    public ResultSet result() {
            return this.result;
    }
}
