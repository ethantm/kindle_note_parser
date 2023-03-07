part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState(
      {this.kindleDrives = const [],
      this.selectedDrive = "",
      this.synced = false,
      this.exported = false,
      this.error = "",
      this.booksList = const [],
      this.selectedBooks = const []});

  final List<String> kindleDrives;
  final String selectedDrive;
  final String error;
  final bool synced;
  final bool exported;
  final List<String> booksList;
  final List<String> selectedBooks;

  @override
  List<Object> get props => [
        kindleDrives,
        error,
        selectedDrive,
        synced,
        exported,
        booksList,
        selectedBooks
      ];

  SettingsState copyWith(
      {List<String>? kindleDrives,
      String? selectedDrive,
      String? error,
      bool? synced,
      bool? exported,
      List<String>? booksList,
      List<String>? selectedBooks}) {
    return SettingsState(
        kindleDrives: kindleDrives ?? this.kindleDrives,
        selectedDrive: selectedDrive ?? this.selectedDrive,
        synced: synced ?? this.synced,
        error: error ?? this.error,
        exported: exported ?? this.exported,
        booksList: booksList ?? this.booksList,
        selectedBooks: selectedBooks ?? this.selectedBooks);
  }
}
