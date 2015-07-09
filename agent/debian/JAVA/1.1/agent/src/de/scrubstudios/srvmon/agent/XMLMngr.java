/*
 * File        : XMLMngr.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 1.1 R1

 * Description : This file is part of the SRVMON AGENT.
 *               This class is used to generate XML data.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
 *  2015-05-11 : Added methods for retrieving and updating services.
 *               Added Javadoc comments.
 *  2015-05-15 : Preparing v1.0.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-05-21 : Finalized R1.
 *  2015-07-08 : Adding encryption capabilities.
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

package de.scrubstudios.srvmon.agent;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Logger;

import javax.net.ssl.HttpsURLConnection;
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

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;

/**
 * XML manager class.
 * This class contains all the necessary functions for the creation and
 * evaluation of XML data from the server. In normal operation, the
 * agent will send XML data to the server which then responds with new
 * XML data. With the received data, we can tell if a query was 
 * successful or retrieve new service checks.
 * @author Pol Warnimont
 * @version 1.1
 */
public class XMLMngr {
	/** Message logger */
	private Logger logger;
	/** Instance of the class itself */
	private static XMLMngr instance;
	
	private String url;
	private String username;
	private String password;
	private String encKey;
	private Date date = new Date();
	
	/**
	 * Constructor for the XMLMngr class.
	 * Initializes the XMLMngr and logger.
	 */
	private XMLMngr() {
		logger = Logger.getLogger("SRVMON-AGENT");
		
		File f = new File("agent.properties");
		Properties prop = new Properties();
		InputStream in = null;
		
		try {
			in = new FileInputStream(f.getName());
			prop.load(in);
			
			url = prop.getProperty("director.url");
			username = prop.getProperty("agent.username");
			password = prop.getProperty("agent.password");
			encKey = prop.getProperty("agent.enckey");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * This method is used in order to determine if there is already an
	 * instance of this class. If no instance of this class exists, the
	 * constructor will be called. Else the method returns the instance
	 * stored in _instance.
	 * @return An instance of the class itself.
	 */
	public static XMLMngr getInstance() {
		if (instance == null) {
			instance = new XMLMngr();
		}
		
		return instance;
	}
	
	/**
	 * This method is used to send an XML message to the server via POST.
	 * If the query was successful on the server, the method will return
	 * the generated XML data from the server.
	 * @param xmlString Contains the XML data which should be send.
	 * @return The XML data from the server.
	 */
	private String postData(String xmlString) {
		System.out.println(new Timestamp(date.getTime()) + " > XML: Sending request to the director...");
		
		try {
			URL durl = new URL(url);
			HttpsURLConnection connection = (HttpsURLConnection)durl.openConnection();
			
			connection.setHostnameVerifier(new HostnameVerifier() {
				public boolean verify(String hostname, SSLSession session) {
					return true;
				}
			});
			
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Content-Type", "text/xml");
			connection.setRequestProperty("Content-Length", Integer.toString(xmlString.getBytes().length));
			connection.setRequestProperty("Content-Language", "en-US");
			connection.setUseCaches(false);
			connection.setDoInput(true);
			connection.setDoOutput(true);
			
			DataOutputStream os = new DataOutputStream(connection.getOutputStream());
			
			os.writeBytes(xmlString);
			os.flush();
			os.close();
			
			InputStream is = connection.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			String line;
			StringBuffer response = new StringBuffer();
			
			while ((line = br.readLine()) != null) {
				response.append(line);
				response.append("\r");
			}
			
			br.close();
			
			return response.toString().trim();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return "";
	}
	
	/**
	 * This method is used to populate an array list containing service 
	 * checks. Firstly, a new XML message is generated and will be 
	 * send to the server. If the agent receives an answer from the
	 * server, the method will then proceed to add every single 
	 * service for the host to the array list and return it.
	 * @param hostid ID of the host which runs the agent.
	 * @return An array list of services for the host.
	 */
	public ArrayList<Service> getServicesFromDirector(int hostid) {
		System.out.println(new Timestamp(date.getTime()) + " > XML: Getting the service list for this agent...");
				
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
	        message.setAttribute("username", username);
			message.setAttribute("password", password);
	        
	        rootElement.appendChild(message);
	        
	        doc.appendChild(rootElement);
	        
	        TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            StringWriter writer = new StringWriter();
            transformer.transform(new DOMSource(doc), new StreamResult(writer));
            String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
	        
            InputSource is;
            is = new InputSource(new StringReader(Crypt.decrypt(encKey, postData(Crypt.encrypt(encKey, xml)))));
            
            doc = docBuilder.parse(is);
            
            NodeList nlistMessage = doc.getElementsByTagName("message");
            Element eMessage = (Element)nlistMessage.item(0);
            
            if (eMessage.getAttribute("qrystatus").equals("0")) {
            	System.out.println(new Timestamp(date.getTime()) + " > XML: Query has been successfully executed on the server.");
            
            	NodeList nList = doc.getElementsByTagName("service");
            
            	for (int temp = 0; temp < nList.getLength(); temp++) {
	                Node nNode = nList.item(temp);
	
	                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
	                    Element eElement = (Element) nNode;
	                    
	                    tmpServices.add(new Service(Integer.valueOf(eElement.getAttribute("sid")), 4, eElement.getAttribute("cmd"), "Check Pending!", eElement.getAttribute("param")));
	                }
            	}
            	
            	return tmpServices;
            }
            else {
            	if (eMessage.getAttribute("error").equals(0)) {
            		System.out.println(new Timestamp(date.getTime()) + " * XML: The specified user credentials are invalid!");
            	}
            	else {
            		System.out.println(new Timestamp(date.getTime()) + " * XML: The query has failed on the server!");
            	}
            }
		} catch (ParserConfigurationException | TransformerException | SAXException | IOException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	/**
	 * This method is needed to receive an ID number for the current 
	 * agent host. The method will create a query on the server which
	 * then retrieves the ID number for the given hostname. This method
	 * is only called once when the agent starts.
	 * @param hostname Hostname of the agent host.
	 * @return The ID number for the given hostname.
	 */
	public int getHostID(String hostname) {
		System.out.println(new Timestamp(date.getTime()) + " > XML: Getting the host ID for this agent...");
		
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder db;
		try {
			db = docFactory.newDocumentBuilder();
			
			Document doc = db.newDocument();
			Element rootElement = doc.createElement("srvmon");
			Element message = doc.createElement("message");
			
			message.setAttribute("hostname", hostname);
			message.setAttribute("action", "getHostID");
			message.setAttribute("username", username);
			message.setAttribute("password", password);
			
			rootElement.appendChild(message);
			
			doc.appendChild(rootElement);
			
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer = tf.newTransformer();
			StringWriter writer = new StringWriter();
			
			transformer.transform(new DOMSource(doc), new StreamResult(writer));
			
			String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
			InputSource is = new InputSource(new StringReader(Crypt.decrypt(encKey, postData(Crypt.encrypt(encKey, xml)))));
			
			doc = db.parse(is);
			
			NodeList nlistMessage = doc.getElementsByTagName("message");
			Element eMessage = (Element)nlistMessage.item(0);
			
			if (eMessage.getAttribute("qrystatus").equals("0")) {
				System.out.println(new Timestamp(date.getTime()) + " > XML: Query has been successfully executed on the server.");
				
				return Integer.parseInt(eMessage.getAttribute("hostid"));
			}
			else {
				if (eMessage.getAttribute("error").equals("0")) {
					System.out.println(new Timestamp(date.getTime()) + " * XML: The specified user credentials are invalid!");
				}
				else {
					System.out.println(new Timestamp(date.getTime()) + " * XML: The query has failed on the server!");
				}
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
	
	/**
	 * This method updates the service check values on the director server.
	 * @param hostid ID for this agent host.
	 * @param service Current executed service.
	 */
	public void updateService(int hostid, Service service) {
		System.out.println(new Timestamp(date.getTime()) + " > XML: Updating the service " + service.getCmd() + "...");
		
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
	        message.setAttribute("username", username);
			message.setAttribute("password", password);
	        
	        rootElement.appendChild(message);
	        
	        doc.appendChild(rootElement);
	        
	        TransformerFactory tf = TransformerFactory.newInstance();
	        Transformer transformer = tf.newTransformer();
	        StringWriter writer = new StringWriter();
	        transformer.transform(new DOMSource(doc), new StreamResult(writer));
	        String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
	        
	        InputSource is;
	        is = new InputSource(new StringReader(Crypt.decrypt(encKey, postData(Crypt.encrypt(encKey, xml)))));
	        
	        doc = docBuilder.parse(is);
            
            NodeList nlistMessage = doc.getElementsByTagName("message");
            Element eMessage = (Element)nlistMessage.item(0);
            
            if (eMessage.getAttribute("qrystatus").equals("0")) {
            	System.out.println(new Timestamp(date.getTime()) + " > XML: Query has been successfully executed on the server.");
            }
            else {
            	if (eMessage.getAttribute("error").equals("0")) {
            		System.out.println(new Timestamp(date.getTime()) + " * XML: The specified user credentials are invalid!");
            	}
            	else {
            		System.out.println(new Timestamp(date.getTime()) + " * XML: The query has failed on the server!");
            	}
            }
        }
        catch (ParserConfigurationException | TransformerException | SAXException | IOException e) {
        	e.printStackTrace();
        }
	}
	
	public String getScriptChecksum(int hostid, Service service) {
		System.out.println(new Timestamp(date.getTime()) + " > XML: Getting the checksum for the service " + service.getCmd() + "...");

		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder;
        
        try {
	        docBuilder = docFactory.newDocumentBuilder();
			
			Document doc = docBuilder.newDocument();
	        Element rootElement = doc.createElement("srvmon");
	        
	        Element message = doc.createElement("message");
	        
	        message.setAttribute("hid", Integer.toString(hostid));
	        message.setAttribute("sid", Integer.toString(service.getID()));
	        message.setAttribute("action", "getChecksum");
	        message.setAttribute("username", username);
			message.setAttribute("password", password);
			
			rootElement.appendChild(message);
	        
	        doc.appendChild(rootElement);
	        
	        TransformerFactory tf = TransformerFactory.newInstance();
	        Transformer transformer = tf.newTransformer();
	        StringWriter writer = new StringWriter();
	        transformer.transform(new DOMSource(doc), new StreamResult(writer));
	        String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
	        
	        InputSource is;
	        is = new InputSource(new StringReader(Crypt.decrypt(encKey, postData(Crypt.encrypt(encKey, xml)))));
	        
	        doc = docBuilder.parse(is);
            
            NodeList nlistMessage = doc.getElementsByTagName("message");
            Element eMessage = (Element)nlistMessage.item(0);
            
            if (eMessage.getAttribute("qrystatus").equals("0")) {
            	System.out.println(new Timestamp(date.getTime()) + " > XML: Query has been successfully executed on the server.");
            
            	return eMessage.getAttribute("checksum");
            }
            else {
            	if (eMessage.getAttribute("error").equals("0")) {
            		System.out.println(new Timestamp(date.getTime()) + " * XML: The specified user credentials are invalid!");
            	}
            	else {
            		System.out.println(new Timestamp(date.getTime()) + " * XML: The query has failed on the server!");
            	}
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
		
		return "";
	}
}
