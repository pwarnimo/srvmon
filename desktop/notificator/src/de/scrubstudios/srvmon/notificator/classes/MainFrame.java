/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.scrubstudios.srvmon.notificator.classes;

import static de.scrubstudios.srvmon.notificator.classes.Main.createImage;
import java.awt.AWTException;
import java.awt.Color;
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.TrayIcon;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowEvent;
import java.io.File;
import java.net.URL;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.DefaultListModel;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import javax.swing.ListModel;
import javax.swing.UIManager;
import javax.swing.plaf.metal.DefaultMetalTheme;
import javax.swing.plaf.metal.MetalLookAndFeel;
import javax.swing.plaf.metal.OceanTheme;

/**
 *
 * @author pwarnimo
 */
public final class MainFrame extends javax.swing.JFrame {
    private static Date date = new Date();
    private ArrayList<Server> servers = new ArrayList<>();
    private Map<String, Server> serverList = new HashMap<>();
    private TrayIcon trayMain;
    private java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("de/scrubstudios/srvmon/notificator/resources/Bundle");
    private Timer timer = new Timer();
    
    /**
     * Creates new form MainFrame
     */
    public MainFrame() {
        initComponents();
        
        lbServers.setModel(new DefaultListModel());
        //lbServices.setModel(new DefaultListModel());
        
        setStatusText("Busy...");
        addStatusMessage(bundle.getString("StatusMsg.Init"));
        
        File f = new File("notificator.properties");
        Properties prop = new Properties();
        
        if (f.exists()) {
            addStatusMessage(bundle.getString("StatusMsg.LoadingCfg"));
        }
        else {
            addStatusMessage(bundle.getString("StatusMsg.MissingCfg"));
        }
        
        final TrayIcon trayMain = new TrayIcon(createImage("/de/scrubstudios/srvmon/notificator/icons/notificatorTray.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        final SystemTray tray = SystemTray.getSystemTray();
        
        try {
            tray.add(trayMain);
        } catch (AWTException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        final PopupMenu mmTray = new PopupMenu();
        
        MenuItem mmiHide2 = new MenuItem("Hide");
        
        mmiHide2.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ae) {                
                setVisible(!isVisible());
            }
        
        });
        
        MenuItem mmiClose = new MenuItem("Quit");
        
        //mmiConnect.doClick();
        
        /*mmiClose.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ae) {
                if (JOptionPane.showConfirmDialog(this, "Do you really want to close this program?", "Question", JOptionPane.YES_NO_OPTION) == 0) {
                    System.exit(0);
                }
            }
        });*/
        
        mmTray.add(mmiHide2);
        mmTray.addSeparator();
        mmTray.add(mmiClose);
        
        trayMain.setPopupMenu(mmTray);
        
        setTrayIcon(trayMain);
        
        trayMain.displayMessage("SRVMON NOTIFICATOR", "Welcome to the SRVMON NOTIFICATOR v0.1", TrayIcon.MessageType.INFO);
        
        final TrayPanel pnlTr = new TrayPanel();
        
        trayMain.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                pnlTr.setVisible(!pnlTr.isVisible());
            }
        });
        
        addStatusMessage(bundle.getString("StatusMsg.Ready"));
        setStatusText("Ready!");
        
        if (f.exists()) {
            refreshServerList();
        
            timer.schedule(new TimerTask() {
                @Override
                public void run() {
                    if (lbServers.getSelectedIndex() > -1) {
                        serverList.get(lbServers.getSelectedValue().toString()).refreshServices();

                        loadServer(lbServers.getSelectedValue().toString());
                        
                        pnlTr.displayServices(getAllFailedServices(serverList));
                    }
                }
            }, 0, 60000);
        }
    }

    private Map<String, ArrayList<Service>> getAllFailedServices(Map<String, Server> servers) {
        Map<String, ArrayList<Service>> tmpServices = new HashMap<>();
        
        for (Map.Entry<String, Server> entry : servers.entrySet()) {
            if (entry.getValue().getServices() != null) {
                ArrayList<Service> tmpArr = new ArrayList<>();
                
                for (int i = 0; i < entry.getValue().getServices().size(); i++) {
                    if (entry.getValue().getServices().get(i).getValue() > 0) {

                        tmpArr.add(entry.getValue().getServices().get(i));
                    }
                }
                
                tmpServices.put(entry.getKey(), tmpArr);
            }
        }
        
        return tmpServices;
    }
    
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
    
    public void setTrayIcon(TrayIcon trayMain) {
        this.trayMain = trayMain;
    }

    public final void addStatusMessage(String message) {
        edtLog.append(new Timestamp(date.getTime()) + "> " + message + "\n");
    }
    
    public final void setStatusText(String message) {
        lblStatus.setText("> " + message);
    }
    
    private void refreshServerList() {
        //servers = XML.getInstance(this).getServers();
        serverList = XML.getInstance(this).getServers();
        
        DefaultListModel listModel = (DefaultListModel)lbServers.getModel();
        
        //for (Map.Entry<String, String> entry : map.entrySet())
        for (Map.Entry<String, Server> entry : serverList.entrySet()) {
            listModel.addElement(entry.getValue().getHostname());
        }
        
        /*for (int i = 0; i < servers.size(); i++) {
            listModel.addElement(servers.get(i).getHostname());
        }*/
        //listModel.addElement("test");
        
        //for (int i = 0; i < serverList.size(); i++) {
            //listModel.addElement(serverList.get(i));
        //}
    }
    
    /*private void refreshServicesForServer(int hostID) {
        
    }*/
    
    private void loadServer(String hostname) {
        //Server tmpServer = servers.get(id);
        Server tmpServer = serverList.get(hostname);
        
        int cntOK = 0;
        int cntWarning = 0;
        int cntCritical = 0;
        int cntPending = 0;
        int cntTimeout = 0;
        
        lblHostname.setText(tmpServer.getHostname());
        lblHardware.setText(tmpServer.getManufacturer() + " " + tmpServer.getModel());
        lblResponsible.setText(tmpServer.getResponsible());
        lblType.setText(tmpServer.getType());
        lblIPAddr.setText(tmpServer.getIPAddress());
        
        if (tmpServer.isEnabled()) {
            pnlStatus.setBackground(Color.green);
        }
        else {
            pnlStatus.setBackground(Color.red);
        }
        
        //DefaultListModel listModel = (DefaultListModel)lbServices.getModel();
        
        //servicePanel1.displayServices(servers.get(host).getServices());
        servicePanel1.displayServices(serverList.get(hostname).getServices());
        
        //for (int i = 0; i < servers.get(id).getServices().size(); i++) {
        /*for (lbServer)
            Service tmpService = servers.get(id).getServices().get(i);
            String status = "UNDEF";
            
            switch (tmpService.getValue()) {
                case 0:
                    status = bundle.getString("ServiceStatus.OK");
                    cntOK++;
                    
                    break;
                    
                case 1:
                    status = bundle.getString("ServiceStatus.Warning");
                    trayMain.displayMessage(servers.get(id).getHostname(), String.format(bundle.getString("ServiceStatus.ChangedWarning"), tmpService.getCaption()), TrayIcon.MessageType.WARNING);
                    cntWarning++;
                    
                    break;
                    
                case 2:
                    status = bundle.getString("ServiceStatus.Critical");
                    trayMain.displayMessage(servers.get(id).getHostname(), String.format(bundle.getString("ServiceStatus.ChangedCritical"), tmpService.getCaption()), TrayIcon.MessageType.ERROR);
                    cntCritical++;
                    
                    break;
                    
                case 3:
                    status = bundle.getString("ServiceStatus.Timeout");;
                    trayMain.displayMessage(servers.get(id).getHostname(), String.format(bundle.getString("ServiceStatus.ChangedTimeout"), tmpService.getCaption()), TrayIcon.MessageType.ERROR);
                    cntTimeout++;
                    
                    break;
                    
                case 4:
                    status = bundle.getString("ServiceStatus.Pending");
                    trayMain.displayMessage(servers.get(id).getHostname(), String.format(bundle.getString("ServiceStatus.ChangedPending"), tmpService.getCaption()), TrayIcon.MessageType.INFO);
                    cntPending++;
                    
                    break;
                    
                default:
                    status = bundle.getString("ServiceStatus.Unkown");
            }
        }
        
        int errMax = Math.max(cntOK, Math.max(cntWarning, Math.max(cntCritical, Math.max(cntTimeout, cntPending))));
            
        if (errMax == cntOK) {
            trayMain.setImage(createImage("../icons/ok-x16.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        }
        else if (errMax == cntWarning) {
            trayMain.setImage(createImage("../icons/warning-x22.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        }
        else if (errMax == cntCritical) {
            trayMain.setImage(createImage("../icons/critical-x16.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        }
        else if (errMax == cntTimeout) {
            trayMain.setImage(createImage("../icons/timeout-x16.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        }
        else if (errMax == cntPending) {
            trayMain.setImage(createImage("../icons/pending-x16.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        }
        else {
            trayMain.setImage(createImage("../icons/unknown-x16.png", "Tray Icon").getScaledInstance(16, 16, Image.SCALE_SMOOTH));
        }*/
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        buttonGroup2 = new javax.swing.ButtonGroup();
        jToolBar1 = new javax.swing.JToolBar();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jSeparator2 = new javax.swing.JToolBar.Separator();
        jButton5 = new javax.swing.JButton();
        jToggleButton1 = new javax.swing.JToggleButton();
        jToggleButton2 = new javax.swing.JToggleButton();
        jSeparator3 = new javax.swing.JToolBar.Separator();
        jButton3 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        lblStatus = new javax.swing.JLabel();
        lblDirector = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        edtLog = new javax.swing.JTextArea();
        jScrollPane2 = new javax.swing.JScrollPane();
        lbServers = new javax.swing.JList();
        jLabel1 = new javax.swing.JLabel();
        lblHostname = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        pnlStatus = new javax.swing.JPanel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        lblHardware = new javax.swing.JLabel();
        lblType = new javax.swing.JLabel();
        lblResponsible = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        servicePanel1 = new de.scrubstudios.srvmon.notificator.classes.ServicePanel();
        jLabel7 = new javax.swing.JLabel();
        lblIPAddr = new javax.swing.JLabel();
        mmMain = new javax.swing.JMenuBar();
        mmiFile = new javax.swing.JMenu();
        mmiConnect = new javax.swing.JMenuItem();
        mmiDisconnect = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        mmiQuit = new javax.swing.JMenuItem();
        mmiView = new javax.swing.JMenu();
        mmiRefresh = new javax.swing.JMenuItem();
        mmiHide = new javax.swing.JMenuItem();
        mmiEdit = new javax.swing.JMenu();
        mmiPrefs = new javax.swing.JMenuItem();
        mmiHelp = new javax.swing.JMenu();
        mmiAbout = new javax.swing.JMenuItem();

        setDefaultCloseOperation(javax.swing.WindowConstants.DO_NOTHING_ON_CLOSE);
        setBounds(new java.awt.Rectangle(50, 50, 0, 0));
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });

        jToolBar1.setBorder(javax.swing.BorderFactory.createMatteBorder(0, 0, 1, 0, new java.awt.Color(153, 153, 153)));
        jToolBar1.setRollover(true);

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/connect-x16.png"))); // NOI18N
        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("de/scrubstudios/srvmon/notificator/resources/Bundle"); // NOI18N
        jButton1.setText(bundle.getString("MainFrame.jButton1.text")); // NOI18N
        jButton1.setToolTipText(bundle.getString("MainFrame.jButton1.toolTipText")); // NOI18N
        jButton1.setFocusable(false);
        jButton1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton1.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiConnectActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton1);

        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/disconnect-x16.png"))); // NOI18N
        jButton2.setText(bundle.getString("MainFrame.jButton2.text")); // NOI18N
        jButton2.setToolTipText(bundle.getString("MainFrame.jButton2.toolTipText")); // NOI18N
        jButton2.setFocusable(false);
        jButton2.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton2.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton2);
        jToolBar1.add(jSeparator2);

        jButton5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/refresh-x16.png"))); // NOI18N
        jButton5.setText(bundle.getString("MainFrame.jButton5.text")); // NOI18N
        jButton5.setFocusable(false);
        jButton5.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton5.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton5);

        buttonGroup1.add(jToggleButton1);
        jToggleButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/start-x16.png"))); // NOI18N
        jToggleButton1.setText(bundle.getString("MainFrame.jToggleButton1.text")); // NOI18N
        jToggleButton1.setFocusable(false);
        jToggleButton1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jToggleButton1.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jToolBar1.add(jToggleButton1);

        buttonGroup1.add(jToggleButton2);
        jToggleButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/pause-x16.png"))); // NOI18N
        jToggleButton2.setText(bundle.getString("MainFrame.jToggleButton1.text")); // NOI18N
        jToggleButton2.setFocusable(false);
        jToggleButton2.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jToggleButton2.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jToolBar1.add(jToggleButton2);
        jToolBar1.add(jSeparator3);

        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/view-x16.png"))); // NOI18N
        jButton3.setText(bundle.getString("MainFrame.jButton3.text")); // NOI18N
        jButton3.setToolTipText(bundle.getString("MainFrame.jButton3.toolTipText")); // NOI18N
        jButton3.setFocusable(false);
        jButton3.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton3.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiHideActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton3);

        jButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/preferences-x16.png"))); // NOI18N
        jButton4.setText(bundle.getString("MainFrame.jButton4.text")); // NOI18N
        jButton4.setToolTipText(bundle.getString("MainFrame.jButton4.toolTipText")); // NOI18N
        jButton4.setFocusable(false);
        jButton4.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jButton4.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiPrefsActionPerformed(evt);
            }
        });
        jToolBar1.add(jButton4);

        jPanel1.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 0, 0, 0, new java.awt.Color(153, 153, 153)));

        lblStatus.setFont(new java.awt.Font("Droid Sans", 0, 10)); // NOI18N
        lblStatus.setText(bundle.getString("MainFrame.lblStatus.text")); // NOI18N

        lblDirector.setFont(new java.awt.Font("Droid Sans", 0, 10)); // NOI18N
        lblDirector.setText(bundle.getString("MainFrame.lblDirector.text")); // NOI18N

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(lblStatus)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(lblDirector))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(lblStatus)
                    .addComponent(lblDirector)))
        );

        edtLog.setBackground(new java.awt.Color(51, 51, 51));
        edtLog.setColumns(20);
        edtLog.setFont(new java.awt.Font("Droid Sans Mono", 0, 11)); // NOI18N
        edtLog.setForeground(new java.awt.Color(204, 204, 204));
        edtLog.setRows(5);
        jScrollPane1.setViewportView(edtLog);

        lbServers.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        lbServers.setModel(new javax.swing.AbstractListModel() {
            String[] strings = { "Not Connected" };
            public int getSize() { return strings.length; }
            public Object getElementAt(int i) { return strings[i]; }
        });
        lbServers.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                lbServersMouseClicked(evt);
            }
        });
        jScrollPane2.setViewportView(lbServers);

        jLabel1.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        jLabel1.setText(bundle.getString("MainFrame.jLabel1.text")); // NOI18N

        lblHostname.setFont(new java.awt.Font("Droid Sans", 1, 18)); // NOI18N
        lblHostname.setForeground(new java.awt.Color(0, 153, 153));
        lblHostname.setText(bundle.getString("MainFrame.lblHostname.text")); // NOI18N

        jLabel3.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        jLabel3.setText(bundle.getString("MainFrame.jLabel3.text")); // NOI18N

        pnlStatus.setBackground(new java.awt.Color(255, 51, 51));
        pnlStatus.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        pnlStatus.setToolTipText(bundle.getString("MainFrame.pnlStatus.toolTipText")); // NOI18N

        javax.swing.GroupLayout pnlStatusLayout = new javax.swing.GroupLayout(pnlStatus);
        pnlStatus.setLayout(pnlStatusLayout);
        pnlStatusLayout.setHorizontalGroup(
            pnlStatusLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 36, Short.MAX_VALUE)
        );
        pnlStatusLayout.setVerticalGroup(
            pnlStatusLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        jLabel4.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        jLabel4.setText(bundle.getString("MainFrame.jLabel4.text")); // NOI18N

        jLabel5.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        jLabel5.setText(bundle.getString("MainFrame.jLabel5.text")); // NOI18N

        jLabel6.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        jLabel6.setText(bundle.getString("MainFrame.jLabel6.text")); // NOI18N

        lblHardware.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        lblHardware.setText(bundle.getString("MainFrame.lblHardware.text")); // NOI18N

        lblType.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        lblType.setText(bundle.getString("MainFrame.lblType.text")); // NOI18N

        lblResponsible.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        lblResponsible.setText(bundle.getString("MainFrame.lblResponsible.text")); // NOI18N

        jLabel2.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        jLabel2.setText(bundle.getString("MainFrame.jLabel2.text")); // NOI18N

        jScrollPane4.setViewportView(servicePanel1);

        jLabel7.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        jLabel7.setText(bundle.getString("MainFrame.jLabel7.text")); // NOI18N

        lblIPAddr.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        lblIPAddr.setText(bundle.getString("MainFrame.lblIPAddr.text")); // NOI18N

        mmiFile.setText(bundle.getString("MainFrame.mmiFile.text")); // NOI18N
        mmiFile.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N

        mmiConnect.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        mmiConnect.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/connect-x16.png"))); // NOI18N
        mmiConnect.setText(bundle.getString("MainFrame.mmiConnect.text")); // NOI18N
        mmiConnect.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiConnectActionPerformed(evt);
            }
        });
        mmiFile.add(mmiConnect);

        mmiDisconnect.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        mmiDisconnect.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/disconnect-x16.png"))); // NOI18N
        mmiDisconnect.setText(bundle.getString("MainFrame.mmiDisconnect.text")); // NOI18N
        mmiFile.add(mmiDisconnect);
        mmiFile.add(jSeparator1);

        mmiQuit.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        mmiQuit.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/exit-x16.png"))); // NOI18N
        mmiQuit.setText(bundle.getString("MainFrame.mmiQuit.text")); // NOI18N
        mmiQuit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiQuitActionPerformed(evt);
            }
        });
        mmiFile.add(mmiQuit);

        mmMain.add(mmiFile);

        mmiView.setText(bundle.getString("MainFrame.mmiView.text")); // NOI18N
        mmiView.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N

        mmiRefresh.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        mmiRefresh.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/refresh-x16.png"))); // NOI18N
        mmiRefresh.setText(bundle.getString("MainFrame.mmiRefresh.text")); // NOI18N
        mmiRefresh.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });
        mmiView.add(mmiRefresh);

        mmiHide.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        mmiHide.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/view-x16.png"))); // NOI18N
        mmiHide.setText(bundle.getString("MainFrame.mmiHide.text")); // NOI18N
        mmiHide.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiHideActionPerformed(evt);
            }
        });
        mmiView.add(mmiHide);

        mmMain.add(mmiView);

        mmiEdit.setText(bundle.getString("MainFrame.mmiEdit.text")); // NOI18N
        mmiEdit.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N

        mmiPrefs.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        mmiPrefs.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/preferences-x16.png"))); // NOI18N
        mmiPrefs.setText(bundle.getString("MainFrame.mmiPrefs.text")); // NOI18N
        mmiPrefs.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiPrefsActionPerformed(evt);
            }
        });
        mmiEdit.add(mmiPrefs);

        mmMain.add(mmiEdit);

        mmiHelp.setText(bundle.getString("MainFrame.mmiHelp.text")); // NOI18N
        mmiHelp.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N

        mmiAbout.setFont(new java.awt.Font("Droid Sans", 0, 12)); // NOI18N
        mmiAbout.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/scrubstudios/srvmon/notificator/icons/about-x16.png"))); // NOI18N
        mmiAbout.setText(bundle.getString("MainFrame.mmiAbout.text")); // NOI18N
        mmiAbout.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                mmiAboutActionPerformed(evt);
            }
        });
        mmiHelp.add(mmiAbout);

        mmMain.add(mmiHelp);

        setJMenuBar(mmMain);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jToolBar1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 160, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 506, Short.MAX_VALUE)
                                .addComponent(jLabel3)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(pnlStatus, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jScrollPane4)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(lblHostname)
                                    .addComponent(jLabel2)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel4)
                                            .addComponent(jLabel5)
                                            .addComponent(jLabel6)
                                            .addComponent(jLabel7))
                                        .addGap(33, 33, 33)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(lblIPAddr)
                                            .addComponent(lblResponsible)
                                            .addComponent(lblType)
                                            .addComponent(lblHardware))))
                                .addGap(0, 0, Short.MAX_VALUE)))))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToolBar1, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(pnlStatus, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel1)
                                .addComponent(jLabel3)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(lblHostname)
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel4)
                            .addComponent(lblHardware))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel5)
                            .addComponent(lblType))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6)
                            .addComponent(lblResponsible))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(lblIPAddr))
                        .addGap(18, 18, 18)
                        .addComponent(jLabel2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 248, Short.MAX_VALUE))
                    .addComponent(jScrollPane2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 117, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void mmiConnectActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mmiConnectActionPerformed
        /*DlgConnectionManager dlgConMngr = new DlgConnectionManager(this, true);
        
        dlgConMngr.setVisible(true);*/
        
        DlgConnect dlgConnection = new DlgConnect(this, true);
        
        dlgConnection.setVisible(true);
        
        refreshServerList();
        
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                if (lbServers.getSelectedIndex() > -1) {
                    serverList.get(lbServers.getSelectedValue().toString()).refreshServices();
                    
                    loadServer(lbServers.getSelectedValue().toString());
                }
            }
        }, 0, 60000);
    }//GEN-LAST:event_mmiConnectActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
       refreshServerList();
       //test
       //loadServer(0);
       //loadServer("debvm");
       lblDirector.setText("Connected");
    }//GEN-LAST:event_jButton5ActionPerformed

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        if (JOptionPane.showConfirmDialog(this, "Do you really want to close this program?", "Question", JOptionPane.YES_NO_OPTION) == 0) {
            System.exit(0);
        }
    }//GEN-LAST:event_formWindowClosing

    private void mmiQuitActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mmiQuitActionPerformed
        this.dispatchEvent(new WindowEvent(this, WindowEvent.WINDOW_CLOSING));
    }//GEN-LAST:event_mmiQuitActionPerformed

    private void mmiAboutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mmiAboutActionPerformed
        DlgAbout frmAbout = new DlgAbout(this, true);
        
        frmAbout.setVisible(true);
    }//GEN-LAST:event_mmiAboutActionPerformed

    private void mmiHideActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mmiHideActionPerformed
        this.setVisible(false);
    }//GEN-LAST:event_mmiHideActionPerformed

    private void mmiPrefsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_mmiPrefsActionPerformed
        DlgSettings dlgSettings = new DlgSettings(this, true);
        
        dlgSettings.setVisible(true);
    }//GEN-LAST:event_mmiPrefsActionPerformed

    private void lbServersMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_lbServersMouseClicked
        //loadServer(serverList.get(lbServers.getSelectedValue().toString()));
        //System.out.println(lbServers.getSelectedValue());
        loadServer(lbServers.getSelectedValue().toString());
    }//GEN-LAST:event_lbServersMouseClicked

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        DefaultListModel listModel = (DefaultListModel) lbServers.getModel();
        
        listModel.removeAllElements();
        servicePanel1.displayServices(null);
        
        timer.cancel();
    }//GEN-LAST:event_jButton2ActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("GTK+".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
            
            //MetalLookAndFeel.setCurrentTheme(new DefaultMetalTheme());
        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException | javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(MainFrame.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new MainFrame().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.JTextArea edtLog;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JPopupMenu.Separator jSeparator1;
    private javax.swing.JToolBar.Separator jSeparator2;
    private javax.swing.JToolBar.Separator jSeparator3;
    private javax.swing.JToggleButton jToggleButton1;
    private javax.swing.JToggleButton jToggleButton2;
    private javax.swing.JToolBar jToolBar1;
    private javax.swing.JList lbServers;
    private javax.swing.JLabel lblDirector;
    private javax.swing.JLabel lblHardware;
    private javax.swing.JLabel lblHostname;
    private javax.swing.JLabel lblIPAddr;
    private javax.swing.JLabel lblResponsible;
    private javax.swing.JLabel lblStatus;
    private javax.swing.JLabel lblType;
    private javax.swing.JMenuBar mmMain;
    private javax.swing.JMenuItem mmiAbout;
    private javax.swing.JMenuItem mmiConnect;
    private javax.swing.JMenuItem mmiDisconnect;
    private javax.swing.JMenu mmiEdit;
    private javax.swing.JMenu mmiFile;
    private javax.swing.JMenu mmiHelp;
    private javax.swing.JMenuItem mmiHide;
    private javax.swing.JMenuItem mmiPrefs;
    private javax.swing.JMenuItem mmiQuit;
    private javax.swing.JMenuItem mmiRefresh;
    private javax.swing.JMenu mmiView;
    private javax.swing.JPanel pnlStatus;
    private de.scrubstudios.srvmon.notificator.classes.ServicePanel servicePanel1;
    // End of variables declaration//GEN-END:variables
}
