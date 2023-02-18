part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState(
      {this.kindleDrives = const [],
      this.selectedDrive = "",
      this.synced = false});

  final List<String> kindleDrives;
  final String selectedDrive;
  final bool synced;

  @override
  List<Object> get props => [
        kindleDrives,
        selectedDrive,
        synced,
      ];

  SettingsState copyWith(
      {List<String>? kindleDrives, String? selectedDrive, bool? synced}) {
    return SettingsState(
        kindleDrives: kindleDrives ?? this.kindleDrives,
        selectedDrive: selectedDrive ?? this.selectedDrive,
        synced: synced ?? this.synced);
  }
}
