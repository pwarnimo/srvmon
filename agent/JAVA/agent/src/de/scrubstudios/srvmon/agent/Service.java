package de.scrubstudios.srvmon.agent;

public class Service {
	private int _id;
	private int _value;
	private String _checkOutput;
	
	public Service(int id, int value, String checkOutput) {
		this._id = id;
		this._value = value;
		this._checkOutput = checkOutput;
	}
	
	public void setID(int id) {
		this._id = id;
	}
	
	public void setValue(int value) {
		this._value = value;
	}
	
	public void setCheckOutput(String checkOutput) {
		this._checkOutput = checkOutput;
	}
	
	public int getID() {
		return this._id; 
	}
	
	public int getValue() {
		return this._value;
	}
	
	public String getCheckOutput() {
		return this._checkOutput;
	}
}
