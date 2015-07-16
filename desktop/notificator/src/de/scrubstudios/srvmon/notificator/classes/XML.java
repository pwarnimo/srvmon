/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.notificator.classes;

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
import java.util.ArrayList;
import java.util.Properties;
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
 *
 * @author pwarnimo
 */
public class XML {
    private static XML instance;
    
    private static String url;
    private static String username;
    private static String password;
    private static String encKey;
    
    private MainFrame frmMain;
    
    private XML(MainFrame parent) {
        frmMain = parent;
    }
    
    public static XML getInstance(MainFrame parent) {
        if (instance == null) {
            instance = new XML(parent);
            
            Properties prop = new Properties();
            InputStream in = null;
            
            try {
                in = new FileInputStream("notificator.properties");
                
                prop.load(in);
                
                url = prop.getProperty("director.url");
                username = prop.getProperty("notificator.username");
                password = prop.getProperty("notificator.password");
                encKey = prop.getProperty("notificator.enckey");
            } catch (FileNotFoundException ex) {
                Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        return instance;
    }
    
    private String performPostRequest(String xmlData) {
        frmMain.addStatusMessage("XML : Sending request to the DIRECTOR server...");
        frmMain.setStatusText("Busy...");
        
        try {
            URL durl = new URL(url);
            HttpsURLConnection connection = (HttpsURLConnection)durl.openConnection();
            
            connection.setHostnameVerifier(new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            });
            
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "text/xml");
            connection.setRequestProperty("Content-Length", Integer.toString(xmlData.getBytes().length));
            connection.setRequestProperty("Content-Language", "en-US");
            connection.setUseCaches(false);
            connection.setDoInput(true);
            connection.setDoOutput(true);
            
            DataOutputStream os = new DataOutputStream(connection.getOutputStream());
            
            os.writeBytes(xmlData);
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
            
            frmMain.setStatusText("Idle");
            
            return response.toString().trim();
        } catch (MalformedURLException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        frmMain.setStatusText("Error encountered!");
        
        return null;
    }
    
    public ArrayList<Service> getServices(int hostID) {
        frmMain.addStatusMessage("XML : Getting services for the host with the ID " + hostID + "...");
        frmMain.setStatusText("Busy...");
        
        ArrayList<Service> tmpServices = new ArrayList<>();
        
        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder;
        
        try {
            docBuilder = docFactory.newDocumentBuilder();
            
            Document doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("srvmon");
            Element message = doc.createElement("message");
            
            message.setAttribute("action", "getFullServiceListForHost");
            message.setAttribute("hid", Integer.toString(hostID));
            message.setAttribute("username", username);
            message.setAttribute("password", password);
            
            rootElement.appendChild(message);
            
            doc.appendChild(rootElement);
            
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            StringWriter writer = new StringWriter();
            
            transformer.transform(new DOMSource(doc), new StreamResult(writer));
            
            String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
            InputSource is = new InputSource(new StringReader(Crypt.decrypt(encKey, performPostRequest(Crypt.encrypt(encKey, xml)))));
            
            doc = docBuilder.parse(is);
            
            Document doc2 = doc;
            transformer.transform(new DOMSource(doc2), new StreamResult(writer));
            
            String xml2 = writer.getBuffer().toString().replaceAll("\n|\r", "");
            
            System.out.println(xml2);
            
            NodeList nlistMessage = doc.getElementsByTagName("message");
            Element eMessage = (Element)nlistMessage.item(0);
            
            switch (eMessage.getAttribute("qrystatus")) {
                case "0":
                    frmMain.addStatusMessage("XML : Query successfully executed on the server, parsing data...");
                    
                    NodeList nList = doc.getElementsByTagName("service");
                    
                    for (int i = 0; i < nList.getLength(); i++) {
                        Node nNode = nList.item(i);
                        
                        if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                            Element eElement = (Element)nNode;
                            
                            tmpServices.add(new Service(Integer.valueOf(eElement.getAttribute("sid")), eElement.getAttribute("caption"), eElement.getAttribute("description"), eElement.getAttribute("checkCommand"), eElement.getAttribute("params"), Integer.parseInt(eElement.getAttribute("value")), eElement.getAttribute("scriptOutput"), eElement.getAttribute("lastCheck")));
                        }
                    }
                    
                    frmMain.addStatusMessage("XML : Command complete!");
                    frmMain.setStatusText("Idle");
                    
                    return tmpServices;
                    
                case "1":
                    if (eMessage.getAttribute("error").equals("0")) {
                        frmMain.addStatusMessage("XML : Your user credentials are invalid!");
                        frmMain.setStatusText("Error encountered!");
                    }
                    else {
                        frmMain.addStatusMessage("XML : The query has failed on the server!");
                        frmMain.setStatusText("Error encountered!");
                    }
                    
                    break;
                    
                case "2":
                    frmMain.addStatusMessage("XML : The current host has no services defined!");
                    frmMain.setStatusText("Idle");
                    
                    break;
                    
                default:
                    frmMain.addStatusMessage("XML : An unknown error has occured!");
                    frmMain.setStatusText("Error encountered!");
            }
        } catch (ParserConfigurationException | TransformerConfigurationException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SAXException | IOException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
    
    public ArrayList<Server> getServers() {
        frmMain.addStatusMessage("XML : Getting list of servers from the DIRECTOR...");
        frmMain.setStatusText("Busy...");
        
        ArrayList<Server> tmpServers = new ArrayList<>();
        
        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder;
        
        try {
            docBuilder = docFactory.newDocumentBuilder();
            
            Document doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("srvmon");
            Element message = doc.createElement("message");
            
            message.setAttribute("action", "getServerList");
            message.setAttribute("username", username);
            message.setAttribute("password", password);
            
            rootElement.appendChild(message);
            
            doc.appendChild(rootElement);
            
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer transformer = tf.newTransformer();
            StringWriter writer = new StringWriter();
            
            transformer.transform(new DOMSource(doc), new StreamResult(writer));
            
            String xml = writer.getBuffer().toString().replaceAll("\n|\r", "");
            InputSource is = new InputSource(new StringReader(Crypt.decrypt(encKey, performPostRequest(Crypt.encrypt(encKey, xml)))));

            doc = docBuilder.parse(is);
            
            NodeList nlistMessage = doc.getElementsByTagName("message");
            Element eMessage = (Element)nlistMessage.item(0);
            
            if (eMessage.getAttribute("qrystatus").equals("0")) {
                frmMain.addStatusMessage("XML : Query successfully executed on the server, parsing data...");
                
                NodeList nList = doc.getElementsByTagName("server");
                
                for (int i = 0; i < nList.getLength(); i++) {
                    Node nNode = nList.item(i);
                    
                    if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element eElement = (Element)nNode;
                        Boolean enabled;
                        
                        if (eElement.getAttribute("enabled").equals("1")) {
                            enabled = true;
                        }
                        else {
                            enabled = false;
                        }
                        
                        Server tmpServer = new Server(frmMain, Integer.valueOf(eElement.getAttribute("hid")), eElement.getAttribute("hostname"), eElement.getAttribute("ipaddr"), eElement.getAttribute("type"), eElement.getAttribute("model"), eElement.getAttribute("manufacturer"), eElement.getAttribute("responsible"), enabled);
                        
                        tmpServer.refreshServices();
                        tmpServers.add(tmpServer);
                    }
                }
                
                frmMain.addStatusMessage("XML : Command complete!");
                frmMain.setStatusText("Idle");
                
                return tmpServers;
            }
            else {
                if (eMessage.getAttribute("error").equals("0")) {
                    frmMain.addStatusMessage("XML : Your user credentials are invalid!");
                    frmMain.setStatusText("Error encountered!");
                }
                else {
                    frmMain.addStatusMessage("XML : The query has failed on the server!");
                    frmMain.setStatusText("Error encountered!");
                }
            }
        } catch (ParserConfigurationException | TransformerConfigurationException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        } catch (TransformerException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SAXException | IOException ex) {
            Logger.getLogger(XML.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }
}
