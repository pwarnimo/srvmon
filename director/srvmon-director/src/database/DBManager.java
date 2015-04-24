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
import main.SettingsManager;

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
}