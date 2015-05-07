/*
 * File        : Main.java
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 0.1

 * Description : This file is part of the SRVMON AGENT.
 *               This class contains the main logic.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created class.
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

import java.util.logging.Logger;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		if (args.length > 0) {
			if (args[0].equals("-v")) {
				System.out.println("SRVMON AGENT 0.1");
				System.out.println("Copyright (C) 2015  Pol Warnimont");
				System.out.println("The SRVMON AGENT comes with ABSOLUTELY NO WARRANTY!");
			}
		}
		else {
			Logger logger = Logger.getLogger("SRVMON-AGENT");
			
			try {
				while (true) {
					logger.info("Invoking thread...");
					new WorkerThread().start();
					logger.info("Sleeping...");
					Thread.sleep(300 * 1000);
				}
			}
			catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

}
