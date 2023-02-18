part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsInit extends SettingsEvent {}

class SettingsKindleSelected extends SettingsEvent {
  const SettingsKindleSelected({required this.kindleDrive});

  final String kindleDrive;
}

class SettingsSyncNotes extends SettingsEvent {}

class SettingsSyncSuccessToggle extends SettingsEvent {}
