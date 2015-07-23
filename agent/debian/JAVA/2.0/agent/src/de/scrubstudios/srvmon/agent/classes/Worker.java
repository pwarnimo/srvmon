/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.agent.classes;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.ResourceBundle;

/**
 *
 * @author pwarnimo
 */
public class Worker extends Thread {
    private int hostid;
    private ArrayList<Service> services = new ArrayList<>();
    private ResourceBundle lang = ResourceBundle.getBundle("de/scrubstudios/srvmon/agent/resource/Lang");
    
    public Worker(int hostid) {
        this.hostid = hostid;
    }
    
    @Override
    public void run() {
        System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER> " + String.format(lang.getString("Agent.Worker.init"), hostid));
        
        services = XML.getInstance().getServicesFromDirector(hostid);
        
        if (!services.isEmpty()) {
            for (int i = 0; i < services.size(); i++) {
                String checksum = XML.getInstance().getScriptChecksum(hostid, services.get(i));
                
                if (Check.isValid(hostid, services.get(i), checksum)) {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " WORKER> " + lang.getString("Agent.Worker.checksumOk"));
                    Check.executeCheck(services.get(i));
                    XML.getInstance().updateService(hostid, services.get(i));
                }
                else {
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
