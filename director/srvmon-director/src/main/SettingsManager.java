/*
 * Class       : SettingsManager
 * Author(s)   : Pol Warnimont <pwarnimo@gmail.com>
 * Create date : 2015-04-23
 * Version     : 0.1
 *
 * Description : This class is used to retrieve the settings for the director.
 *               The files are read from a XML file called settings.xml.
 *
 * Changelog
 * ---------
 *  2015-04-23 : Created class.
 *
 * License information
 * -------------------
 *  Copyright (C) 2015  Pol Warnimont
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package main;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 *
 * @author pwarnimo
 */
public class SettingsManager {
    private File settingsFile;
    private HashMap<String, String> database_s = new HashMap<>();
    private HashMap<String, String> director_s = new HashMap<>();
    
    public SettingsManager() {
        System.out.println("> SettingsManager class init...");
        
        settingsFile = new File("settings.xml");
        
        if (settingsFile.exists() && !settingsFile.isDirectory()) {
            System.out.println(" + Loading settings.xml");
        }
        else {
            System.out.println(" + Warning settings.xml not found!");
        }
        
        System.out.println("> SettingsManager class Ok.");
    }
    
    public void loadDBSettingsFromXML() {
        database_s.clear();
        
        DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
        try {
            DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
            Document doc = docBuilder.parse(settingsFile);
            
            System.out.println(" + ROOT = " + doc.getDocumentElement().getTagName());
            
            NodeList nList = doc.getElementsByTagName("database");
            
            for (int i = 0; i < nList.getLength(); i++) {
                NodeList nOptions = nList.item(i).getChildNodes();
                
                for (int j = 0; j < nOptions.getLength(); j++) {
                    Node childNode = nOptions.item(j);
                    if ("option".equals(childNode.getNodeName())) {
                        Element option = (Element)childNode;
                        
                        System.out.println(" + OPT[" + option.getAttribute("caption") + "] = " + option.getTextContent());
                        database_s.put(option.getAttribute("caption"), option.getTextContent());
                    }
                }
            }
        } catch (ParserConfigurationException | SAXException | IOException ex) {
            Logger.getLogger(SettingsManager.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void loadDirectorSettingsFromXML() {
        
    }
    
    public String getDatabaseSetting(String key) {
        return database_s.get(key);
    }
    
    public String getDirectorSetting(String key) {
        return database_s.get(key);
    }
}
