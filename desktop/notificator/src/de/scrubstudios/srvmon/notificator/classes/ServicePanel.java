/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.notificator.classes;

import java.util.ArrayList;
import javax.swing.JEditorPane;
import javax.swing.text.Document;
import javax.swing.text.html.HTML;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.StyleSheet;

/**
 *
 * @author pwarnimo
 */
public class ServicePanel extends JEditorPane {
    private String table = "<table><tr><th>Status</th><th>Caption</th><th>Description</th><th>Ouput</th></tr>%s</table>";
    
    public ServicePanel() {
        setEditable(false);
        HTMLEditorKit kit = new HTMLEditorKit();
        
        setEditorKit(kit);
        
        StyleSheet styleSheet = kit.getStyleSheet();
        styleSheet.addRule(".ok {background-color : #00ff00; color : #000000;}");
        styleSheet.addRule(".warn {background-color : #ffff00; color : #000000;}");
        styleSheet.addRule(".crit {background-color : #ff0000; color : #ffffff;}");
        styleSheet.addRule(".timeout {background-color : #000000; color : #ffffff;}");
        styleSheet.addRule(".pending {background-color : #0000ff; color : #ffffff;}");
        styleSheet.addRule("table {border-collapse: collapse;}");
        styleSheet.addRule("tr {border : 1px solid #000;}");
        styleSheet.addRule("td, th {border : 1px dotted #000;}");
        
        Document doc = kit.createDefaultDocument();
        setDocument(doc);
           
        //kit.insertHTML(doc, WIDTH, table, WIDTH, WIDTH, HTML.Tag.APPLET);
        
        setText(String.format(table, "<tr><td colspan=\"4\">No selection!</td></tr>"));
    }
    
    public void displayServices(ArrayList<Service> services) {
        //setText(String.format(table, "<tr><td>r</td><td>r</td><td>r</td></tr>"));
        if (services.size() > 0) {
            String serviceHtml = "";
            
            for (int i = 0; i < services.size(); i++) {
                String color = "";
                String status = "";
                
                switch (services.get(i).getValue()) {
                    case 0:
                        color = "ok";
                        status ="OK";
                        
                        break;
                        
                    case 1:
                        color = "warn";
                        status = "WARNING";
                        
                        break;
                        
                    case 2:
                        color = "crit";
                        status = "CRITICAL";
                        
                        break;
                        
                    case 3:
                        color = "timeout";
                        status ="TIMEOUT";
                        
                        break;
                        
                    case 4:
                        color = "pending";
                        status ="PENDING";
                        
                        break;
                }
                
                System.out.println(color);
                
                serviceHtml += "<tr class=\"" + color + "\"><td>" + status + "</td>"
                        + "<td>" + services.get(i).getCaption() + "</td>"
                        + "<td>" + services.get(i).getCheckCommand() + "</td>"
                        + "<td>" + services.get(i).getScriptOutput() + "</td></tr>";
            }
            
            System.out.println(serviceHtml);
            
            setText(String.format(table, serviceHtml));
        }
        else {
            setText(String.format(table, "<tr><td colspan=\"4\">This host has no services!</td></tr>"));
        }
    }
}
