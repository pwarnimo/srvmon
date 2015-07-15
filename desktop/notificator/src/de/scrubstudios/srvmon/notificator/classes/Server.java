/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.notificator.classes;

/**
 *
 * @author pwarnimo
 */
public class Server {
    private int hostID;
    private String IPAddress;
    private String hostname;
    private String type;
    private String model;
    private String manufacturer;
    private String responsible;
    private Boolean enabled;
    
    public Server(int hostID, String hostname, String IPAddress, String type, String model, String manufacturer, String responsible, Boolean enabled) {
        this.hostID = hostID;
        this.hostname = hostname;
        this.IPAddress = IPAddress;
        this.type = type;
        this.model = model;
        this.manufacturer = manufacturer;
        this.responsible = responsible;
        this.enabled = enabled;
    }
    
    public void setID(int hostID) {
        this.hostID = hostID;
    }
    
    public void setHostname(String hostname) {
        this.hostname = hostname;
    }
    
    public void setIPAddress(String IPAddress) {
        this.IPAddress = IPAddress;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public void setModel(String model) {
        this.model = model;
    }
    
    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }
    
    public void setResponsible(String responsible) {
        this.responsible = responsible;
    }
    
    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }
    
    public int getID() {
        return hostID;
    }
    
    public String getHostname() {
        return hostname;
    }
    
    public String getIPAddress() {
        return IPAddress;
    }
    
    public String getType() {
        return type;
    }
    
    public String getModel() {
        return model;
    }
    
    public String getManufacturer() {
        return manufacturer;
    }
    
    public String getResponsible() {
        return responsible;
    }
    
    public Boolean isEnabled() {
        return enabled;
    }
}
