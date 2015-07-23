/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.agent.classes;

/**
 *
 * @author pwarnimo
 */
public class Service {
    private int id;
    private int value;
    private String cmd;
    private String checkOutput;
    private String parameters;
    
    public Service(int id, int value, String cmd, String checkOutput, String parameters) {
        this.id = id;
        this.value = value;
        this.cmd = cmd;
        this.checkOutput = checkOutput;
        this.parameters = parameters;
    }
    
    public void setID(int id) {
        this.id = id;
    }
    
    public void setValue(int value) {
        this.value = value;
    }
    
    public void setCmd(String cmd) {
        this.cmd = cmd;
    }
    
    public void setCheckOutput(String checkOutput) {
        this.checkOutput = checkOutput;
    }
    
    public void setParameters(String parameters) {
        this.parameters = parameters;
    }
    
    public int getID() {
        return id;
    }
    
    public int getValue() {
        return value;
    }
    
    public String getCmd() {
        return cmd;
    }
    
    public String getCheckOutput() {
        return checkOutput;
    }
    
    public String getParameters() {
        return parameters;
    }
}
