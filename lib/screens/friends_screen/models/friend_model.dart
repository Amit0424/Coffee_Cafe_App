class FriendModel {
  final String friendId;
  final String name;
  final String imageUrl;
  final String email;
  final String phoneNumber;
  final bool isOnline;
  final String gender;
  final DateTime lastOnline;

  FriendModel({
    required this.friendId,
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.phoneNumber,
    required this.isOnline,
    required this.gender,
    required this.lastOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'friendId': friendId,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'gender': gender,
      'lastOnline': lastOnline,
    };
  }

  factory FriendModel.fromMap(String friendId, Map<String, dynamic> map) {
    return FriendModel(
      friendId: friendId,
      name: map['name'] ?? 'User',
      imageUrl: map['profileImageUrl'] ??
          'https://firebasestorage.googleapis.com/v0/b/coffee-cafe-app-45ff3.appspot.com/o/profileImages%2Fboy_profile.png?alt=media&token=4a360718-892e-4d0f-b2b0-981ed78e7d5f',
      email: map['email'] ?? 'mail.website.com',
      phoneNumber: map['phone'] ?? '1234567890',
      isOnline: map['isOnline'] ?? false,
      gender: map['gender'] ?? 'male',
      lastOnline: map['lastOnline'].toDate() ?? DateTime.now(),
    );
  }
}
