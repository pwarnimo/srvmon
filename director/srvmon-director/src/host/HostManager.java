/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package host;

import java.util.ArrayList;

/**
 *
 * @author pwarnimo
 */
public class HostManager {
    private ArrayList<Host> hosts = new ArrayList<>();
    
    public HostManager() {
        System.out.println("> HostManager init...");
        System.out.println("> Hostmanager class Ok.");
    }
    
    public void addHost(int ID, String IPAddress, String Hostname, boolean Status) {
        hosts.add(new Host(ID, IPAddress, Hostname, Status));
    }
}
