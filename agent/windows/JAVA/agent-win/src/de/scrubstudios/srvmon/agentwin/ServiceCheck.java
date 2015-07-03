package de.scrubstudios.srvmon.agentwin;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ServiceCheck {
	public static void executeCheck(Service check) {
		try {
			Process p = Runtime.getRuntime().exec("powershell checkscripts/" + check.getCmd());
			p.waitFor();
			
			BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line = "";
			
			while ((line = reader.readLine()) != null) {
				String[] output = line.split(";");
				check.setValue(Integer.parseInt(output[0]));
				check.setCheckOutput(output[1]);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
