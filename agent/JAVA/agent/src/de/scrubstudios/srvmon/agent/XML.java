package de.scrubstudios.srvmon.agent;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

public class XML {
	private DocumentBuilderFactory docFactory;
	private DocumentBuilder docBuilder;
	
	public XML() {
		docFactory = DocumentBuilderFactory.newInstance();
		try {
			docBuilder = docFactory.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		}
	}
	
	public void getServicesXML(int hostid) {
		Document doc = docBuilder.newDocument();
        Element rootElement = doc.createElement("message");
	}
}
