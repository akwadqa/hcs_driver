import 'package:equatable/equatable.dart';

class ProfileParams extends Equatable {
  final String? name;
  final String? mobileNo;
  final String? password;
  final String? imagePath;

  const ProfileParams({
    required this.name,
    required this.mobileNo,
    required this.password,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [name, mobileNo, password, imagePath];
}
