class ChatModel {
  ChatModel({
    required this.id,
    required this.userId,
    required this.chatMessage,
    required this.senderName,
    required this.senderEmail,
    required this.time,
    required this.isDeleted,
  });

  String id;
  String userId;
  String chatMessage;
  String senderName;
  String senderEmail;
  String time;
  bool isDeleted;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        userId: json["userId"],
        chatMessage: json["chatMessage"],
        senderName: json["senderName"],
        senderEmail: json["senderEmail"],
        time: json["time"],
        isDeleted: json["isDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "chatMessage": chatMessage,
        "senderName": senderName,
        "senderEmail": senderEmail,
        "time": time,
        "isDeleted": isDeleted,
      };
}
