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
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.ImageIcon;

/**
 *
 * @author pwarnimo
 */
public class Main {
    private static MainFrame frmMain;
    
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
        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("de/scrubstudios/srvmon/notificator/resources/Bundle");
        
        frmMain = new MainFrame();
        
        frmMain.setStatusText("Busy...");
        frmMain.setVisible(true);
        frmMain.addStatusMessage(bundle.getString("StatusMsg.Init"));
        // INIT...
        
        File f = new File("notificator.properties");
        Properties prop = new Properties();
        
        if (f.exists()) {
            frmMain.addStatusMessage(bundle.getString("StatusMsg.LoadingCfg"));
        }
        else {
            frmMain.addStatusMessage(bundle.getString("StatusMsg.MissingCfg"));
            
            // TEMP
            
            OutputStream out = null;
            
            try {
                out = new FileOutputStream("notificator.properties");
                
                prop.setProperty("director.url", "https://127.0.0.1/updater/");
                prop.setProperty("notificator.username", "srvmonag");
                prop.setProperty("notificator.password", "agnt123.");
                prop.setProperty("notificator.enckey", "1DCFE6F852819FE3");

                prop.store(out, null);
            } catch (FileNotFoundException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            // TEMP
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
        
        mmiHide.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ae) {                
                frmMain.setVisible(!frmMain.isVisible());
            }
        
        });
        
        MenuItem mmiClose = new MenuItem("Quit");
        
        mmiClose.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ae) {
                frmMain.dispatchEvent(new WindowEvent(frmMain, WindowEvent.WINDOW_CLOSING));
            }
        });
        
        mmTray.add(mmiHide);
        mmTray.addSeparator();
        mmTray.add(mmiClose);
        
        trayMain.setPopupMenu(mmTray);
        
        frmMain.setTrayIcon(trayMain);
        
        // INIT...
        
        trayMain.displayMessage("SRVMON NOTIFICATOR", "Welcome to the SRVMON NOTIFICATOR v0.1", TrayIcon.MessageType.INFO);
        
        //trayMain.setImage(createImage("../icons/warning-x22.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        
        frmMain.addStatusMessage(bundle.getString("StatusMsg.Ready"));
        frmMain.setStatusText("Ready!");
        
        //***
        
        //XML.getInstance(frmMain).getServers();
    }
    
}
