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
public class Service {
    private int serviceID;
    private String caption;
    private String description;
    private String checkCommand;
    private String parameters;
    private int value;
    private String scriptOutput;
    private String lastCheck;
    private boolean notified = false;
    
    public Service(int serviceID, String caption, String description, String checkCommand, String parameters, int value, String scriptOutput, String lastCheck) {
        this.serviceID = serviceID;
        this.caption = caption;
        this.description = description;
        this.checkCommand = checkCommand;
        this.parameters = parameters;
        this.value = value;
        this.scriptOutput = scriptOutput;
        this.lastCheck = lastCheck;
    }
    
    public void setID(int serviceID) {
        this.serviceID = serviceID;
    }
    
    public void setCaption(String caption) {
        this.caption = caption;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setCheckCommand(String checkCommand) {
        this.checkCommand = checkCommand;
    }
    
    public void setParameters(String parameters) {
        this.parameters = parameters;
    }
    
    public void setValue(int value) {
        this.value = value;
    }
    
    public void setScriptOutput(String scriptOutput) {
        this.scriptOutput = scriptOutput;
    }
    
    public void setLastCheck(String lastCheck) {
        this.lastCheck = lastCheck;
    }
    
    public void setNotified(boolean notified) {
        this.notified = notified;
    }
    
    public int getID() {
        return serviceID;
    }
    
    public String getCaption() {
        return caption;
    }
    
    public String getDescription() {
        return description;
    }
    
    public String getCheckCommand() {
        return checkCommand;
    }
    
    public String getParameters() {
        return parameters;
    }
    
    public int getValue() {
        return value;
    }
    
    public String getScriptOutput() {
        return scriptOutput;
    }
    
    public String getLastCheck() {
        return lastCheck;
    }
    
    public boolean isNotified() {
        return notified;
    }
}
