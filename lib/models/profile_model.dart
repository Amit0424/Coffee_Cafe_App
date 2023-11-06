class Profile {
  Profile({
    required this.name,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.profileImageUrl,
    required this.profileBackgroundImageUrl,
  });

  late String name;
  late DateTime dateOfBirth;
  late String phoneNumber;
  late String email;
  late String profileImageUrl;
  late String profileBackgroundImageUrl;
}

final profile = Profile(
  name: '',
  dateOfBirth: DateTime.now(),
  phoneNumber: '',
  email: '',
  profileImageUrl: '',
  profileBackgroundImageUrl: '',
);
