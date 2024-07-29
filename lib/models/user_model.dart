class UserModel {
  final String email;
  final String? userName;
  final dynamic password;

  UserModel({required this.email, required this.password, this.userName});
}
