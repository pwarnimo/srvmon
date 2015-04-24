/*
 * Class       : DBManager
 * Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
 * Create date : 2015-04-23
 * Version     : 0.1
 *
 * Description : This class is used to exchange data with the SQL server.
 *
 * Changelog
 * ---------
 *  2015-04-23 : Created class.
 *
 * License information
 * -------------------
 *  Copyright (C) 2015  Pol Warnimont
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package database;

import com.mysql.jdbc.Connection;
import host.Host;
import host.HostManager;
import main.SettingsManager;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author pwarnimo
 */
public class DBManager {
    private SettingsManager settingsmngr;
    private String username;
    private String password;
    private String server;
    private String dbname;
    private Connection dbcon;
    
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    
    public DBManager() {
        System.out.println("> DBManager class init...");
        
        settingsmngr = new SettingsManager();
        settingsmngr.loadDBSettingsFromXML();
        
        username = settingsmngr.getDatabaseSetting("user");
        password = settingsmngr.getDatabaseSetting("password");
        server = settingsmngr.getDatabaseSetting("server");
        dbname = settingsmngr.getDatabaseSetting("dbname");
        
        System.out.println("> DBManager class Ok.");
    }
    
    private void connectToDB() {
        System.out.println(" + Connecting to DB " + dbname + "@" + server);
        try {
            dbcon = (Connection) DriverManager.getConnection("jdbc:mysql://" + server + "/" + dbname, username, password);
            System.out.println(" + Connected");
        } catch (SQLException ex) {
            Logger.getLogger(DBManager.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private void closeDBConnection() {
        System.out.println(" + Disconnecting . . .");
        try {
            dbcon.close();
            System.out.println(" + Disconnected");
        } catch (SQLException ex) {
            Logger.getLogger(DBManager.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void getServers() {
        Statement stmt = null;
        HostManager tmpHosts = new HostManager();
        
        connectToDB();
        
        try {
            stmt = dbcon.createStatement();
            String sql = "CALL getServer(-1,FALSE,@err)";
            
            ResultSet res = stmt.executeQuery(sql);
            
            while (res.next()) {
                System.out.println(" | " + res.getInt("idServer") + ":" + res.getString("dtHostname") + ":" + res.getString("dtIPAddress"));
                tmpHosts.addHost(res.getInt("idServer"), res.getString("dtIPAddress"), res.getString("dtHostname"), res.getBoolean("dtEnabled"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBManager.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        closeDBConnection();
    }
}
