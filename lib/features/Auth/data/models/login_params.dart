import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String email;
  final String pass;

  const LoginParams({required this.email, required this.pass});

  @override
  List<Object?> get props => [email, pass];
}
