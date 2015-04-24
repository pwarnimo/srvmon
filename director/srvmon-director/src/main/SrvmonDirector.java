/*
 * Class       : SrvmonDirector
 * Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
 * Create date : 2015-04-23
 * Version     : 0.1
 *
 * Description : This is the main class of the director.
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

package main;

import database.DBManager;

/**
 *
 * @author pwarnimo
 */
public class SrvmonDirector {
    private static DBManager dbmngr;
    private static SettingsManager settingsmngr;
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        System.out.println("SRVMON DIRECTOR 0.1 INIT . . .");
        dbmngr = new DBManager();
        System.out.println("*** SRVMON DIRECTOR READY ***");
        
        dbmngr.getServers();
    }
    
}
