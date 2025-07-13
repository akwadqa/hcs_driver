import 'package:equatable/equatable.dart';
import 'package:hcs_driver/features/settings/data/models/profile_model.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends SettingsState {}

class ProfileLoading extends SettingsState {}

class ProfileLoaded extends SettingsState {
  final ProfileModel profileModel;
  final String? message;

  const ProfileLoaded({required this.profileModel, this.message});
}

class ProfileError extends SettingsState {
  final String? message;

  const ProfileError({this.message});
}
