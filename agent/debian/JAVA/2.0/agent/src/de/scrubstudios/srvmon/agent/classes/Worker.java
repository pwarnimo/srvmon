/*
 * File        : Worker.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 2.0 P1
 * Description : This file is part of the SRVMON AGENT.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
 *  2015-05-15 : Preparing v1.0.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-23 : Completely reworked the agent.
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

package de.scrubstudios.srvmon.agent.classes;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.ResourceBundle;

/**
 * This class defines a worker thread.
 * In this class a thread for a worker is defined. The worker thread is used to 
 * get an up to date list of services for this agent from the director server. 
 * The worker then proceeds to execute the check scripts for the retrieved 
 * services and updates the values accordingly. The worker thread thread will be
 * periodically invoked from the main class.
 * @author Pol Warnimont
 * @version 2.0
 */
public class Worker extends Thread {
    /** ID number for the current agent */
    private final int hostid;
    /** Array list for the services */
    private ArrayList<Service> services = new ArrayList<>();
    /** Resource bundle for the multi-language support. */
    private final ResourceBundle lang = ResourceBundle.getBundle("de/scrubstudios/srvmon/agent/resource/Lang");
    
    /**
     * The constructor sets the ID number for the current agent host.
     * @param hostid ID number of the agent.
     */
    public Worker(int hostid) {
        this.hostid = hostid;
    }
    
    /**
     * This method performs the service checks. The method runs trough all 
     * available service checks which are stored in the _services array list and
     * the executes the check commands. The output of the check commands are 
     * then updated on the director server.
     */
    @Override
    public void run() {
        System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER> " + String.format(lang.getString("Agent.Worker.init"), hostid));
        
        services = XML.getInstance().getServicesFromDirector(hostid);
        
        if (!services.isEmpty()) {
            for (Service service : services) {
                String checksum = XML.getInstance().getScriptChecksum(hostid, service);
                if (Check.isValid(hostid, service, checksum)) {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER> " + lang.getString("Agent.Worker.checksumOk"));
                    Check.executeCheck(service);
                    XML.getInstance().updateService(hostid, service);
                } else {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER* " + lang.getString("Agent.Worker.checksumFailed"));
                }
            }
        }
        else {
            System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER* " + lang.getString("Agent.Worker.noServices"));
        }
        
        System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER> " + lang.getString("Agent.Worker.finished"));
    }
}
