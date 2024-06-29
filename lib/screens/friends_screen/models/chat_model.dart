class DeleteModel {
  final bool status;
  late bool isForMe;
  final DateTime deleteTime;

  DeleteModel({
    required this.status,
    required this.isForMe,
    required this.deleteTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'isForMe': isForMe,
      'deleteTime': deleteTime,
    };
  }

  factory DeleteModel.fromMap(Map<String, dynamic> map) {
    return DeleteModel(
      status: map['status'] ?? false,
      isForMe: map['isForMe'] ?? false,
      deleteTime: map['deleteTime'].toDate() ?? DateTime.now(),
    );
  }
}

class ChatModel {
  final String chatId;
  final String content;
  final DateTime time;
  late bool isSender;
  final String messageType;
  final DeleteModel delete;

  ChatModel({
    required this.chatId,
    required this.content,
    required this.time,
    required this.isSender,
    required this.messageType,
    required this.delete,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'content': content,
      'time': time,
      'isSender': isSender,
      'messageType': messageType,
      'delete': delete.toMap(),
    };
  }

  factory ChatModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatModel(
      chatId: id,
      content: map['content'] ?? '',
      time: map['time'].toDate() ?? DateTime.now(),
      isSender: map['isSender'] ?? false,
      messageType: map['messageType'] ?? 'text',
      delete: DeleteModel.fromMap(map['delete'] as Map<String, dynamic>),
    );
  }
}
