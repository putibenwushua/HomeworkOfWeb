package com.dw.webSocket;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.lang3.ArrayUtils;

import com.alibaba.fastjson.JSONObject;
import com.dw.pojo.Msg;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/chatroom")
public class WSServPoint {

	static Map<Session, String> us = new HashMap<Session, String>();
	Map<String, String> map;
	private Msg ms;

	@OnOpen
	public void onOpen(Session session) throws UnsupportedEncodingException {
		System.out.println("link successfully");
		String msg = session.getQueryString();
		msg = URLDecoder.decode(msg, "utf-8");
		map = new HashMap<String, String>();
		if (msg.contains("&")) {
			String[] sts = msg.split("\\&");
			for (String str : sts) {
				String[] strs = str.split("=");
				map.put(strs[0], strs[1]);
			}
		} else {
			String[] strs = msg.split("=");
			map.put(strs[0], strs[1]);
		}

		System.out.println("map:" + map);
		us.put(session, map.get("loginName"));
		ms = new Msg();
		ms.setType("s");
		ms.setMsgSender("system");
		ms.setMsgDate(new Date());
		ms.setUserList(new ArrayList<String>(us.values()));
		ms.setMsgInfo(" " + map.get("loginName") + " is Online!");
		String jsonStr = JSONObject.toJSONString(ms);

		bordcast(us.keySet(), jsonStr);
	}

	@OnClose
	public void onClose(Session session) {

		us.remove(session);
		ms = new Msg();
		ms.setType("s");
		ms.setMsgSender("system");
		ms.setMsgDate(new Date());
		ms.setUserList(new ArrayList<String>(us.values()));
		ms.setMsgInfo(" " + map.get("loginName") + " is offline!");
		String jsonStr = JSONObject.toJSONString(ms);

		bordcast(us.keySet(), jsonStr);
		System.out.println("link closed");
	}

	@OnMessage
	public void onMessage(String message, Session session) throws IOException {
		System.out.println("信息接收成功");
		Msg ms = new Msg();
		ms.setType("p");
		ms.setMsgSender(map.get("loginName"));
		ms.setMsgDate(new Date());

		if (message.startsWith("@") && message.contains(":")) {
			String reivName = message.substring(message.indexOf("@") + 1, message.indexOf(":"));
			if (us.containsValue(reivName)) {
				for (Entry<Session, String> e : us.entrySet()) {
					if (reivName.equals(e.getValue())) {
						Session reivSession = e.getKey();
						message = message.substring(message.indexOf(":") + 1);
						ms.setMsgInfo("銆恜rivate message銆�:" + " " + message);
						ms.setMsgReceiver(reivName);
						String jsonstr = JSONObject.toJSONString(ms);
						Set<Session> hashSet = new HashSet<Session>();
						hashSet.add(reivSession);
						hashSet.add(session);
						bordcast(hashSet, jsonstr);
						break;
					}
				}

			} else {
				ms.setMsgInfo(message);
				String jsonstr = JSONObject.toJSONString(ms);
				bordcast(us.keySet(), jsonstr);
			}
		} else {
			ms.setMsgInfo(message);
			String jsonstr = JSONObject.toJSONString(ms);
			bordcast(us.keySet(), jsonstr);

		}

	}

	byte[] bc = null;

	@OnMessage
	public void onMessage(byte[] input, Session session, boolean flag) {
		if (!flag) {

			bc = ArrayUtils.addAll(bc, input);
		} else {

			bc = ArrayUtils.addAll(bc, input);
			ByteBuffer bb = ByteBuffer.wrap(bc);

			bordcast(us.keySet(), bb);
			bc = null;
			Msg ms = new Msg();
			ms.setMsgSender(map.get("loginName"));
			ms.setMsgDate(new Date());
			ms.setType("img");
			String jsonstr = JSONObject.toJSONString(ms);
			bordcast(us.keySet(), jsonstr);
		}

	}

	@OnError
	public void onError(Throwable t) throws Throwable {
		System.out.println("System error!msg:");
	}

	public void bordcast(Set<Session> set, String message) {
		for (Session s : set) {
			try {
				s.getBasicRemote().sendText(message);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void bordcast(Set<Session> set, ByteBuffer bb) {
		for (Session s : set) {
			try {
				s.getBasicRemote().sendBinary(bb);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}
}
