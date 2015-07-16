/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.notificator.classes;

import java.awt.Graphics;
import javax.swing.JScrollPane;

/**
 *
 * @author pwarnimo
 */
public class ServicePanel extends JScrollPane {
    public ServicePanel() {
        super();
    }
    
    @Override
    public void paintComponent(Graphics g) {
        super.paintChildren(g);
        
        g.drawString("test1", 10, 10);
    }
}
