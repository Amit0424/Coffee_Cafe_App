class ChatModel {
  ChatModel({
    required this.id,
    required this.userId,
    required this.chatMessage,
    required this.senderName,
    required this.senderEmail,
    required this.time,
    required this.isDeleted,
    required this.type,
    required this.mediaUrl,
  });

  String id;
  String userId;
  String chatMessage;
  String senderName;
  String senderEmail;
  DateTime time;
  String type;
  String mediaUrl;
  bool isDeleted;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        userId: json["userId"],
        chatMessage: json["chatMessage"],
        senderName: json["senderName"],
        senderEmail: json["senderEmail"],
        time: json["time"].toDate(),
        isDeleted: json["isDeleted"],
        type: json["type"],
        mediaUrl: json["mediaUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "chatMessage": chatMessage,
        "senderName": senderName,
        "senderEmail": senderEmail,
        "time": time,
        "isDeleted": isDeleted,
        "type": type,
        "mediaUrl": mediaUrl,
      };
}
