/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package host;

/**
 *
 * @author pwarnimo
 */
public class Host {
    private int ID;
    private String IPAddress;
    private String Hostname;
    private boolean Status;
    
    public Host(int ID, String IPAddress, String Hostname, boolean Status) {
        System.out.println("> Initializing host...");
        this.ID = ID;
        this.IPAddress = IPAddress;
        this.Hostname = Hostname;
        this.Status = Status;
        System.out.println("> OK [" + ID + ":" + IPAddress + ":" + Hostname + ":" + Status + "]");
    }
    
    public int getID() {
        return ID;
    }
    
    public String getIPAddress() {
        return IPAddress;
    }
    
    public String getHostname() {
        return Hostname;
    }
    
    public boolean getStatus() {
        return Status;
    }
}
