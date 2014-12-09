package org.lasti.websocketchat;

import org.lasti.websocketchat.common.Conf;
import org.lasti.websocketchat.common.ConfKey;
import org.lasti.websocketchat.websocket.WebChatServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App {
	private static final Logger logger=LoggerFactory.getLogger(App.class);
	
	public static void main(String[] args) throws InterruptedException {
		logger.info("started");
		
		Conf.set(ConfKey.PORT, "1234");
		Conf.set(ConfKey.WEB_SOCKET_PORT, "1235");
		
		WebChatServer.startServer(Integer.parseInt(Conf.get(ConfKey.WEB_SOCKET_PORT)));
		
		JettyServer jetty=new JettyServer();
		jetty.start();
		jetty.join();
	} //main
} //class