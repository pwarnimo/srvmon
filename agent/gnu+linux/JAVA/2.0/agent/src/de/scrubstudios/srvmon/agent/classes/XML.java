/*
 * File        : XML.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 2.0 P1
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
 *  2015-07-23 : Completely reworked the agent.
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

package de.scrubstudios.srvmon.agent.classes;

import java.io.BufferedReader;
import java.io.DataOutputStream;
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
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;
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
 * XML class.
 * This class contains all the necessary functions for the creation and 
 * evaluation of XML data from the server. In normal operation, the agent will 
 * send XML data to the server which then responds with new XML data. With the 
 * received data, we can tell if a query was successful or retrieve new service 
 * checks.
 * @author Pol Warnimont
 * @version 2.0
 */
public class XML {
    /** Resource bundle for the multi-language support. */
    private static final ResourceBundle lang = ResourceBundle.getBundle("de/scrubstudios/srvmon/agent/resource/Lang");
    /** Instance of the class itself. */
    private static XML instance;
    
    /** URL of the Director server. */
    private String url;
    /** Username for the Director server. */
    private String username;
    /** Password for the Director server. */
    private String password;
    /** Encryption key for the connection between the Director and Agent. */
    private String encKey;
    
    private XML() {
        Properties prop = new Properties();
        
        try {
            InputStream in = new FileInputStream("/etc/srvmon/agent.properties");
            
            prop.load(in);
            
            url = prop.getProperty("director.url");
            username = prop.getProperty("agent.username");
            password = prop.getProperty("agent.password");
            encKey = prop.getProperty("agent.enckey");
        } catch (FileNotFoundException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
     * This method is used in order to determine if there is already an instance
     * of this class. If no instance of this class exists, the constructor will
     * be called. Else the method returns the instance stored in instance.
     * @return An instance of the class itself.
     */
    public static XML getInstance() {
        if (instance == null) {
            instance = new XML();
        }
        
        return instance;
    }
    
    /**
     * This method is used to send an XML message to the server via POST. If the 
     * query was successful on the server, the method will return the generated 
     * XML data from the server.
     * @param xml Contains the XML data which should be send.
     * @return The XML data from the server.
     */
    private String postData(String xml) {
        System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.sendingRequest"));
        
        try {
            URL dUrl = new URL(url);
            HttpsURLConnection connection = (HttpsURLConnection)dUrl.openConnection();
            
            connection.setHostnameVerifier(new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            });
            
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "text/xml");
            connection.setRequestProperty("Content-Length", Integer.toString(xml.getBytes().length));
            connection.setRequestProperty("Content-Language", "en-US");
            connection.setUseCaches(false);
            connection.setDoInput(true);
            connection.setDoOutput(true);
            
            DataOutputStream os;
            
            os = new DataOutputStream(connection.getOutputStream());
            
            os.writeBytes(xml);
            os.flush();
            os.close();
            
            InputStream is = connection.getInputStream();
            BufferedReader br;
            
            br = new BufferedReader(new InputStreamReader(is));
            
            String line;
            StringBuilder response = new StringBuilder();
            
            while ((line = br.readLine()) != null) {
                response.append(line);
                response.append("\r");
            }
            
            br.close();
            
            return response.toString().trim();
        } catch (MalformedURLException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
    
    /**
     * This method is needed to receive an ID number for the current agent host. 
     * The method will create a query on the server which then retrieves the ID
     * number for the given hostname. This method is only called once when the 
     * agent starts.
     * @param hostname Hostname of the agent host.
     * @return The ID number for the given hostname.
     */
    public int getHostID(String hostname) {
        System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.getHostID"));

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
                System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.queryOK"));

                return Integer.parseInt(eMessage.getAttribute("hostid"));
            }
            else {
                if (eMessage.getAttribute("error").equals("0")) {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.invalidCreds"));
                }
                else {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.queryFailed"));
                }
            }
        } catch (ParserConfigurationException | SAXException | IOException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerConfigurationException ex) {
                Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerException ex) {
                Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return 0;
    }
    
    /**
     * This method is used to populate an array list containing service checks. 
     * Firstly, a new XML message is generated and will be send to the server. 
     * If the agent receives an answer from the server, the method will then 
     * proceed to add every single service for the host to the array list and 
     * return it.
     * @param hostid ID of the host which runs the agent.
     * @return An array list of services for the host.
     */
    public ArrayList<Service> getServicesFromDirector(int hostid) {
        System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.getServices"));

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
                System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.queryOK"));

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
                if (eMessage.getAttribute("error").equals("0")) {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.invalidCreds"));
                }
                else {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.queryFailed"));
                }
            }
        } catch (ParserConfigurationException | TransformerException | SAXException | IOException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }
    
    /**
     * This method updates the service check values on the director server.
     * @param hostid ID for this agent host.
     * @param service Current executed service.
     */
    public void updateService(int hostid, Service service) {
        System.out.println(String.format(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.updateService"), service.getCmd()));

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
                System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.queryOK"));
            }
            else {
                if (eMessage.getAttribute("error").equals("0")) {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.invalidCreds"));
                }
                else {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.queryFailed"));
                }
            }
        }
        catch (ParserConfigurationException | TransformerException | SAXException | IOException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
     * This method return the checksum for the given script.
     * @param hostid ID number of the current Agent host.
     * @param service Current service.
     * @return The checksum of the given service.
     */
    public String getScriptChecksum(int hostid, Service service) {
        System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + String.format(lang.getString("Agent.XML.getChecksum"), service.getCmd()));

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
            	System.out.println(new Timestamp(System.currentTimeMillis()) + " XML> " + lang.getString("Agent.XML.queryOK"));
            
            	return eMessage.getAttribute("checksum");
            }
            else {
            	if (eMessage.getAttribute("error").equals("0")) {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.invalidCreds"));
            	}
            	else {
                    System.out.println(new Timestamp(System.currentTimeMillis()) + " XML* " + lang.getString("Agent.XML.queryFailed"));
            	}
            }
        } catch (ParserConfigurationException | SAXException | IOException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerConfigurationException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerException ex) {
            Logger.getLogger(Check.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
}
