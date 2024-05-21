String BASE_URL = "https://5844-2402-4000-2340-d85a-c9f3-6adc-5b70-5882.ngrok-free.app";
String WS_URL = "ws://5844-2402-4000-2340-d85a-c9f3-6adc-5b70-5882.ngrok-free.app/ws";
//===============================================================
String getUserPath(String userID) => "/api/user/"+userID;
String getUserByMobilePath(String mobile) => "/api/user/mobile/"+mobile;
String getAllUsersByRoomIdPath(String roomId) => "/api/chat-room/get-users/"+roomId;
String sendMessagePath(String roomId) => "/message/"+roomId;
String getOfflineMessagePath(String roomId) => "/message/get-relay-messages/"+roomId;
String removeOfflineMessagePath(String roomId) => "/message/remove-offline-messages/"+roomId;
String GET_ALL_ROOMS = "/api/chat-room/public/get-all";
String PRIVATE_ROOMS = "/private-chat-room";
String REGISTER_USER = "/api/user/register";
String CREATE_CHAT_ROOM = "/api/chat-room/public";
String LOGIN = "/api/user/login";
String ADD_MEMBER_TO_CHAT = "/api/chat-room/public/add-user";

//=============== NOT IN USED
String wsSubscribe(String chatRoomId) =>
    "/topic/" + chatRoomId + ".public.messages";
String SEND_MESSAGE = "/api/messages";
String GET_MESSAGES = "/api/messages";
String GET_USER_BY_MOBILE = "/by-mobile/";

