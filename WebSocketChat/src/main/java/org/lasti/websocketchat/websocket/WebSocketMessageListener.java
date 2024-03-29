package org.lasti.websocketchat.websocket;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.ObjectMessage;

import org.java_websocket.WebSocket;
import org.json.JSONObject;
import org.lasti.websocketchat.mq.ActiveMQAdapter;
import org.lasti.websocketchat.mq.ChatMessage;

import com.google.common.base.Preconditions;
import com.sun.istack.internal.NotNull;

public class WebSocketMessageListener implements MessageListener {
	private WebSocket socket;

	public WebSocketMessageListener(@NotNull WebSocket socket) throws NullPointerException {
		Preconditions.checkNotNull(socket);
		this.socket = socket;
	} // INIT

	@Override
	public void onMessage(Message message) {
		try {
			if (socket.isClosed()) {
				ActiveMQAdapter.unlisten(this);
				return;
			} // if

			ChatMessage chatMsg = (ChatMessage) ((ObjectMessage) message).getObject();
			JSONObject json=new JSONObject();
			json.put("sender", chatMsg.getSenderNickname());
			json.put("msg", chatMsg.getMsg());
			socket.send(json.toString());
		} catch (JMSException e) {
			e.printStackTrace();
		} // catch
	} // onMessage
} // class