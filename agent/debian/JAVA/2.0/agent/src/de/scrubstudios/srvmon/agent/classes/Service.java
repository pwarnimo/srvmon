/*
 * File        : Service.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-05
 * Version     : 2.0 P1
 * Description : This file is part of the SRVMON agent.
 *               This class defines a service check.
 *
 * Changelog
 * ---------
 *  2015-05-09 : Created class.
 *  2015-05-11 : Added Javadoc comments.
 *  2015-05-15 : Preparing version 1.0.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-23 : Completely reworking the agent.
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

/**
 * This class defines a single service check.
 * @author Pol Warnimont
 * @version 2.0
 */
public class Service {
    /** ID number of the service. */
    private int id;
    /** Return value of the service check script */
    private int value;
    /** Command for executing the check script */
    private String cmd;
    /** Output of the check script */
    private String checkOutput;
    /** Parameters for the check script */
    private String parameters;
    
    /**
     * Constructor for the Service class.
     * Initializes and creates a new service instance.
     * @param id ID number for the new service.
     * @param value Check value for the new service (Usually 4).
     * @param cmd Command for the new service check.
     * @param checkOutput Output of the new service (Usually "Check Pending!").
     * @param parameters Parameters which will be passed to the checkscript.
     */
    public Service(int id, int value, String cmd, String checkOutput, String parameters) {
        this.id = id;
        this.value = value;
        this.cmd = cmd;
        this.checkOutput = checkOutput;
        this.parameters = parameters;
    }
    
    /**
     * This method sets the ID number of the service check.
     * @param id ID number of the service.
     */
    public void setID(int id) {
        this.id = id;
    }

    /**
     * This method sets the return value of the service check.
     * @param value Return value of the service check.
     */
    public void setValue(int value) {
        this.value = value;
    }

    /**
     * This method sets the check command which should be executed.
     * @param cmd Check command name.
     */
    public void setCmd(String cmd) {
        this.cmd = cmd;
    }

    /**
     * This method stores the output of the service check script.
     * @param checkOutput Output of the service check.
     */
    public void setCheckOutput(String checkOutput) {
        this.checkOutput = checkOutput;
    }

    /**
     * This method stores the parameters for the service check script.
     * @param parameters 
     */
    public void setParameters(String parameters) {
        this.parameters = parameters;
    }

    /**
     * This method returns the ID number of the service check.
     * @return The ID number of the check.
     */
    public int getID() {
        return id; 
    }

    /**
     * This method returns the return value of the executed service check.
     * @return The return value of the service check.
     */
    public int getValue() {
        return value;
    }

    /**
     * This method gets the name of the service check command.
     * @return The name of the service check command.
     */
    public String getCmd() {
        return cmd;
    }

    /**
     * This method returns the output of the executed service check.
     * @return The output of the executed service check.
     */
    public String getCheckOutput() {
        return checkOutput;
    }

    /**
     * This method returns the parameters for the service check.
     * @return The current script parameters.
     */
    public String getParameters() {
        return parameters;
     }
}
