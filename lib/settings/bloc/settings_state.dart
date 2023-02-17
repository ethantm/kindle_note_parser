part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.kindleDrives = const [],
    this.selectedDrive = "",
  });
  
  final List<String> kindleDrives;
  final String selectedDrive;

  @override
  List<Object> get props => [
    kindleDrives,
    selectedDrive,
  ];

  SettingsState copyWith({
    List<String>? kindleDrives,
    String? selectedDrive,
  }) {
    return SettingsState(
      kindleDrives: kindleDrives ?? this.kindleDrives,
      selectedDrive: selectedDrive ?? this.selectedDrive,
    );
  }
}