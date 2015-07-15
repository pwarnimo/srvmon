/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.notificator.classes;

import java.awt.AWTException;
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.TrayIcon;
import java.io.File;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.ImageIcon;

/**
 *
 * @author pwarnimo
 */
public class Main {
    protected static Image createImage(String path, String description) {
        URL imageURL = Main.class.getResource(path);
        
        if (imageURL == null) {
            System.out.println("Resource not found!");
            
            return null;
        }
        else {
            return (new ImageIcon(imageURL, description)).getImage();
        }
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        MainFrame frmMain = new MainFrame();
        
        frmMain.setStatusText("Busy...");
        frmMain.setVisible(true);
        frmMain.addStatusMessage("SRVMON NOTIFICATOR is initializing...");
        // INIT...
        
        File f = new File("notificator.properties");
        
        if (f.exists()) {
            frmMain.addStatusMessage("Loading preferences from config file...");
        }
        else {
            frmMain.addStatusMessage("Config file is missing, generating new file...");
        }
        
        final TrayIcon trayMain = new TrayIcon(createImage("../icons/notificatorTray.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        final SystemTray tray = SystemTray.getSystemTray();
        
        //trayMain.setImageAutoSize(true);
        
        try {
            tray.add(trayMain);
        } catch (AWTException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        final PopupMenu mmTray = new PopupMenu();
        
        MenuItem mmiHide = new MenuItem("Hide");
        MenuItem mmiClose = new MenuItem("Quit");
        
        mmTray.add(mmiHide);
        mmTray.addSeparator();
        mmTray.add(mmiClose);
        
        trayMain.setPopupMenu(mmTray);
        
        // INIT...
        
        trayMain.displayMessage("SRVMON NOTIFICATOR", "Welcome to the SRVMON NOTIFICATOR v0.1", TrayIcon.MessageType.INFO);
        
        //trayMain.setImage(createImage("../icons/warning-x22.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        
        frmMain.addStatusMessage("NOTIFICATOR is ready for operations.");
        frmMain.setStatusText("Ready!");
    }
    
}
