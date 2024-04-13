import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female, other }

Gender genderSelection(String gender) {
  switch (gender) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'other':
      return Gender.other;
    default:
      return Gender.male;
  }
}

String genderToString(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 'male';
    case Gender.female:
      return 'female';
    case Gender.other:
      return 'other';
    default:
      return 'male';
  }
}

class ProfileModel {
  ProfileModel({
    required this.name,
    required this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.profileImageUrl,
    required this.profileBackgroundImageUrl,
    required this.accountCreatedDate,
    required this.gender,
    required this.lastOnline,
    required this.latitude,
    required this.longitude,
    required this.lastLocationName,
  });

  String name;
  String dateOfBirth;
  String phone;
  String email;
  String profileImageUrl;
  String profileBackgroundImageUrl;
  String accountCreatedDate;
  DateTime lastOnline;
  double latitude;
  double longitude;
  Gender gender;
  String lastLocationName;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'profileBackgroundImageUrl': profileBackgroundImageUrl,
      'latitude': latitude,
      'phone': phone,
      'longitude': longitude,
      'dateOfBirth': dateOfBirth,
      'accountCreatedDate': accountCreatedDate,
      'lastOnline': lastOnline,
      'gender': gender,
      'lastLocationName': lastLocationName,
    };
  }

  factory ProfileModel.fromDocument(DocumentSnapshot map) {
    return ProfileModel(
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      profileImageUrl: map['profileImageUrl'],
      profileBackgroundImageUrl: map['profileBackgroundImageUrl'],
      dateOfBirth: map['dateOfBirth'],
      accountCreatedDate: map['accountCreatedDate'],
      lastOnline: map['lastOnline'].toDate(),
      longitude: map['longitude'] ?? 0.0,
      latitude: map['latitude'] ?? 0.0,
      gender: genderSelection(map['gender']),
      lastLocationName: map['lastLocationName'],
    );
  }
}
