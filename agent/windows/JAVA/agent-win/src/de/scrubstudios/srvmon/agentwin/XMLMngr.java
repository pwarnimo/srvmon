/*
 * File        : XMLMngr.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-07-03
 * Version     : 0.5
 * Description : This file is part of the SRVMON AGENT.
 *               This class is used to generate XML data.
 *
 * Changelog
 * ---------
 *  2015-07-03 : Created class
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

package de.scrubstudios.srvmon.agentwin;

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.helpers.Loader;
import org.apache.log4j.nt.NTEventLogAppender;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Level;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * XML manager class.
 * This class contains all the necessary functions for the creation and
 * evaluation of XML data from the server. In normal operation, the
 * agent will send XML data to the server which then responds with new
 * XML data. With the received data, we can tell if a query was 
 * successful or retrieve new service checks.
 * @author Pol Warnimont
 * @version 0.5
 */
public class XMLMngr {
	private static XMLMngr _instance;
	private static Logger _logger = Logger.getLogger(XMLMngr.class);
	
	private XMLMngr() {
		//BasicConfigurator.configure();
		NTEventLogAppender eventLogAppender = new NTEventLogAppender();
		eventLogAppender.setSource("srvmon-agent"); 
		eventLogAppender.setLayout(new PatternLayout("%m")); 
		eventLogAppender.activateOptions(); 
		_logger.addAppender(eventLogAppender);
	}
	
	public static XMLMngr getInstance() {
		if (_instance == null) {
			_instance = new XMLMngr();
		}
		
		return _instance;
	}
	
	private String postData(String xmlString) {
		_logger.info("Sending XML request to the director...");
		
		URL url;
		HttpURLConnection connection = null
				;
		Properties prop = new Properties();
		
		try {
			InputStream in = new FileInputStream("agent.properties");
			prop.load(in);
			url = new URL(prop.getProperty("director.url"));
			connection = (HttpURLConnection) url.openConnection();
			
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type", "text/xml");
			connection.setRequestProperty("Content-Length", Integer.toString(xmlString.getBytes().length));
			connection.setRequestProperty("Content-Language", "en-US");
			
			connection.setUseCaches(false);
			connection.setDoInput(true);
			connection.setDoOutput(true);
			
			DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
			
			wr.writeBytes(xmlString);
			wr.flush();
			wr.close();
			
			InputStream is = connection.getInputStream();
			BufferedReader rd = new BufferedReader(new InputStreamReader(is));
			String line;
			StringBuffer response = new StringBuffer();
			
			while ((line = rd.readLine()) != null) {
				response.append(line);
				response.append("\r");
			}
			
			rd.close();
			
			return response.toString().trim();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	public int getHostID(String hostname) {
		_logger.info("Getting hostid for agent host with the name " + hostname + ".");
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		
		try {
			docBuilder = docFactory.newDocumentBuilder();
			
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("srvmon");
			Element message = doc.createElement("message");
			
			message.setAttribute("hostname", hostname);
			message.setAttribute("action", "getHostID");
			
			rootElement.appendChild(message);
			
			doc.appendChild(rootElement);
			
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer = tf.newTransformer();
			StringWriter writer = new StringWriter();
			
			transformer.transform(new DOMSource(doc), new StreamResult(writer));
			
			String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
			
			InputSource is;
			
			is = new InputSource(new StringReader(postData(xml)));
			
			doc = docBuilder.parse(is);
			
			NodeList nlistMessage = doc.getElementsByTagName("message");
			Element eMessage = (Element)nlistMessage.item(0);
			
			if (eMessage.getAttribute("qrystatus").equals("0")) {
				_logger.info("The Query was successfully executed on the server.");
				
				return Integer.parseInt(eMessage.getAttribute("hostid"));
			}
			else {
				_logger.warn("The Query has failed on the server!");
			}
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return 0;
	}
	
	public ArrayList<Service> getServicesFromDirector(int hostid) {
		_logger.info("Getting a list of services for this agent...");
		
		ArrayList<Service> tmpServices = new ArrayList<>();
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		
		try {
			docBuilder = docFactory.newDocumentBuilder();
			
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("srvmon");
			Element message = doc.createElement("message");
			
			message.setAttribute("hid", Integer.toString(hostid));
			message.setAttribute("action", "getServices");
			
			rootElement.appendChild(message);
			
			doc.appendChild(rootElement);
			
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer = tf.newTransformer();
			StringWriter writer = new StringWriter();
			
			transformer.transform(new DOMSource(doc), new StreamResult(writer));
			
			String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
			
			InputSource is;
			
			is = new InputSource(new StringReader(postData(xml)));
			doc = docBuilder.parse(is);
			
			NodeList nlistMessage = doc.getElementsByTagName("message");
			Element eMessage = (Element)nlistMessage.item(0);
			
			if (eMessage.getAttribute("qrystatus").equals("0")) {
				_logger.info("The Query was successfully executed on the server.");
				
				NodeList nList = doc.getElementsByTagName("service");
				
				for (int temp = 0; temp < nList.getLength(); temp++) {
					Node nNode = nList.item(temp);
					
					if (nNode.getNodeType() == Node.ELEMENT_NODE) {
						Element eElement = (Element)nNode;
						
						tmpServices.add(new Service(Integer.valueOf(eElement.getAttribute("sid")), 4, eElement.getAttribute("cmd"), "Check Pending!"));
					}
				}
				
				return tmpServices;
			}
			else {
				_logger.warn("The Query has failed on the server.");
			}
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	public void updateService(int hostid, Service service) {
		_logger.info("Updating service...");
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder;
		
		try {
			docBuilder = docFactory.newDocumentBuilder();
		
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("updateServiceData");
			Element message = doc.createElement("message");
			
			message.setAttribute("hid", Integer.toString(hostid));
			message.setAttribute("sid", Integer.toString(service.getID()));
			message.setAttribute("val", Integer.toString(service.getValue()));
			message.setAttribute("msg", service.getCheckOutput());
			message.setAttribute("action", "updateServiceData");
			
			rootElement.appendChild(message);
			doc.appendChild(rootElement);
			
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer = tf.newTransformer();
			StringWriter writer = new StringWriter();
			
			transformer.transform(new DOMSource(doc), new StreamResult(writer));
			
			String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");

			InputSource is;
			
			is = new InputSource(new StringReader(postData(xml)));
			doc = docBuilder.parse(is);
			
			NodeList nlistMessage = doc.getElementsByTagName("message");
			Element eMessage = (Element)nlistMessage.item(0);
			
			if (eMessage.getAttribute("qrystatus").equals("0")) {
				_logger.info("The Query was successfully executed on the server.");
			}
			else {
				_logger.warn("The Query has failed on the server!");
			}
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
