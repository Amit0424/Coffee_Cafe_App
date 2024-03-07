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

class Profile {
  Profile({
    required this.name,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.profileImageUrl,
    required this.profileBackgroundImageUrl,
  });

  String name;
  String dateOfBirth;
  String phoneNumber;
  String email;
  String profileImageUrl;
  String profileBackgroundImageUrl;
  String accountCreatedDate;
  String lastOnline;
  double latitude;
  double longitude;
  Gender gender;
}
