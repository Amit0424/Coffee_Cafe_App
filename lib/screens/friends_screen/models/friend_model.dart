class FriendModel {
  final String friendId;
  final String name;
  final String imageUrl;
  final String email;
  final String phoneNumber;
  final bool isOnline;

  FriendModel({
    required this.friendId,
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.phoneNumber,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'friendId': friendId,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
    };
  }

  factory FriendModel.fromMap(String friendId, Map<String, dynamic> map) {
    return FriendModel(
      friendId: friendId,
      name: map['name'] ?? 'User',
      imageUrl: map['imageUrl'] ?? 'https://via.placeholder.com/150',
      email: map['email'] ?? 'mail.website.com',
      phoneNumber: map['phoneNumber'] ?? '1234567890',
      isOnline: map['isOnline'] ?? false,
    );
  }
}
