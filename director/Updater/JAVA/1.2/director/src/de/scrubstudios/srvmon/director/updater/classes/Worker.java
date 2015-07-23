/*
 * File        : Worker.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 1.2 P1
 * Description : This file is part of the SRVMON director.
 *               This class implements a worker thread which checks all 
 *               hosts for their status. The thread is executed on a user 
 *               defined interval.
 *
 * Changelog
 * ---------
 *  2015-05-05 : Created class.
 *  2015-05-07 : Finalized director updater.
 *  2015-05-12 : Starting v1.1.
 *  2015-05-13 : Modified run() method to use new DBng class.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-23 : Preparing for package release P1.
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

package de.scrubstudios.srvmon.director.updater.classes;

import java.io.IOException;
import java.net.InetAddress;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

/** Worker class.
 * This class defines a so called "worker thread". A worker thread is used to 
 * check all available hosts in the database for their online status. The worker
 * thread fetches a list of hosts and then check if the host is reachable by 
 * using the java method InetAddress.getByName().isReachable(). The updated 
 * status for the hosts is then written to the database. The worker thread will 
 * be called periodically from the Main class.
 * @author Pol Warnimont
 * @version 1.2
 */
public class Worker {
        /** Resource bundle for the multi-language support. */
        private static final ResourceBundle lang = ResourceBundle.getBundle("de/scrubstudios/srvmon/director/updater/resources/Lang");
        
        /** 
	 * This method defines the thread which is called in the main class. The
         * run() method will be periodically called and the host status is then 
         * determined and updated.
	 */
	public void run() {
            System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER > " + lang.getString("Director.Worker.Run"));

            if (DB.getInstance().query("CALL getServer(-1, TRUE, @err)", null).error() == false) {
                try {
                    ResultSet res = DB.getInstance().result();

                    while (res.next()) {
                        if (InetAddress.getByName(res.getString("dtIPAddress")).isReachable(2000)) {

                            System.out.println(String.format(new Timestamp(System.currentTimeMillis()) + " WORKER > " + lang.getString("Director.Worker.IsReachable"), res.getString("dtHostname"), res.getString("dtIPAddress")));

                            ArrayList<QueryParam> params = new ArrayList<>();

                            params.add(new QueryParam(SQLTypeEnum.INT, String.valueOf(res.getInt("idServer"))));

                            DB.getInstance().query("CALL setSystemStatus(?, TRUE, @err)", params);
                        }
                        else {

                            System.out.println(String.format(new Timestamp(System.currentTimeMillis()) + " WORKER * " + lang.getString("Director.Worker.NotReachable"), res.getString("dtHostname"), res.getString("dtIPAddress")));
                            
                            ArrayList<QueryParam> params = new ArrayList<>();

                            params.add(new QueryParam(SQLTypeEnum.INT, String.valueOf(res.getInt("idServer"))));

                            DB.getInstance().query("CALL setSystemStatus(?, FALSE, @err)", params);
                            DB.getInstance().query("CALL disableChildrenChecks(?,@err)", params);
                        }
                    }
                } catch (SQLException | IOException ex) {
                    Logger.getLogger(Worker.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            else {
                System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER * " + lang.getString("Director.Worker.DBError"));
            }

        System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER > " + lang.getString("Director.Worker.ThreadFinished"));
    }
}
