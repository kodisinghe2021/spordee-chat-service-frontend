String BASE_URL = "https://b4ab-124-43-78-217.ngrok-free.app";
String WS_URL = "ws://b4ab-124-43-78-217.ngrok-free.app/ws";
//===============================================================
String getUserPath(String userID) => "/api/user/"+userID;
String getUserByMobilePath(String mobile) => "/api/user/mobile/"+mobile;
String getChatRoomsPath(String userID) => "/public-chat-room/"+userID;
String getAllUserListPath(String roomId) => "/public-chat-room/get-users/"+roomId;
String sendMessagePath(String roomId) => "/message/"+roomId;
String getOfflineMessagePath(String userId, String roomId) => "/message/"+userId+"/"+roomId  ;
String REGISTER_USER = "/api/user/register";
String CREATE_CHAT_ROOM = "/public-chat-room";
String LOGIN = "/api/user/login";
String ADD_MEMBER_TO_CHAT = "/public-chat-room/add-user";

//=============== NOT IN USED
String wsSubscribe(String chatRoomId) =>
    "/topic/" + chatRoomId + ".public.messages";
String SEND_MESSAGE = "/api/messages";
String GET_MESSAGES = "/api/messages";
String GET_USER_BY_MOBILE = "/by-mobile/";

