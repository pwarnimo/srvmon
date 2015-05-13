/*
 * File        : XMLMngr.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 0.1

 * Description : This file is part of the SRVMON AGENT.
 *               This class is used to generate XML data.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
 *  2015-05-11 : Added methods for retrieving and updating services.
 *               Added Javadoc comments.
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
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

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
 * @version 0.1
 */
public class XMLMngr {
	/** Message logger */
	private Logger _logger;
	/** Instance of the class itself */
	private static XMLMngr _instance;
	
	/**
	 * Constructor for the XMLMngr class.
	 * Initializes the XMLMngr and logger.
	 */
	private XMLMngr() {
		_logger = Logger.getLogger("SRVMON-AGENT");
	}
	
	public static XMLMngr getInstance() {
		if (_instance == null) {
			_instance = new XMLMngr();
		}
		
		return _instance;
	}
	
	/**
	 * This method is used to send an XML message to the server via POST.
	 * If the query was successful on the server, the method will return
	 * the generated XML data from the server.
	 * @param xmlString Contains the XML data which should be send.
	 * @return The XML data from the server.
	 */
	private String postData(String xmlString) {
		URL url;
        HttpURLConnection connection = null;

        try {
            url = new URL("http://127.0.0.1/srvmon-updater/");

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
                response.append('\r');
            }
            rd.close();

            return response.toString().trim();
		} catch (MalformedURLException ex) {
	        Logger.getLogger(XMLMngr.class.getName()).log(Level.SEVERE, null, ex);
	        return null;
	    } catch (IOException ex) {
	        Logger.getLogger(XMLMngr.class.getName()).log(Level.SEVERE, null, ex);
	        return null;
	    }
	}
	
	/**
	 * This method is used to populate an arraylist containing service 
	 * checks. Firstly, a new XML message is generated and will be 
	 * send to the server. If the agent receives an answer from the
	 * server, the method will then proceed to add every single 
	 * service for the host to the arraylist and return it.
	 * @param hostid ID of the host which runs the agent.
	 * @return An arraylist of services for the host.
	 */
	public ArrayList<Service> getServicesFromDirector(int hostid) {
		_logger.info("XMLMNGR> Sending XML request to director...");
		
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
            	System.out.println("XMLMngr> Query was successfully executed on the server.");
            
            	NodeList nList = doc.getElementsByTagName("service");
            
            	for (int temp = 0; temp < nList.getLength(); temp++) {
	                Node nNode = nList.item(temp);
	
	                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
	                    Element eElement = (Element) nNode;
	                    
	                    tmpServices.add(new Service(Integer.valueOf(eElement.getAttribute("sid")), 4, eElement.getAttribute("cmd"), "Check Pending!"));
	                }
            	}
            	
            	return tmpServices;
            }
            else {
            	System.out.println("XMLMngr> The query has failed on the server!");
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
		_logger.info("XMLMNGR> Sending XML request to director...");
		
		return 0;
	}
}
