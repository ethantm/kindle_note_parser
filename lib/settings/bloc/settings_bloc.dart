import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kindle_repository/kindle_repository.dart';
import 'package:kindle_repository/models/models.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final KindleRepository _kindleRepository;

  SettingsBloc(KindleRepository kindleRepository)
      : _kindleRepository = kindleRepository,
        super(const SettingsState()) {
    on<SettingsInit>((event, emit) {
      List<String> kindles = _kindleRepository.getKindles();
      emit(state.copyWith(kindleDrives: kindles));
    });

    on<SettingsKindleSelected>((event, emit) {
      emit(state.copyWith(selectedDrive: event.kindleDrive));
    });

    on<SettingsSyncNotes>((event, emit) async {
      if (state.selectedDrive.isNotEmpty) {
        List<String> notes =
            await _kindleRepository.getNotesFromFile(state.selectedDrive);

        Map<String, List<Note>> parsedNotes =
            _kindleRepository.parseNotes(notes);

        _kindleRepository.storeNotes(parsedNotes);

        emit(state.copyWith(synced: true));
      }
    });

    on<SettingsSyncSuccessToggle>((event, emit) {
      emit(state.copyWith(synced: !state.synced));
    });
  }
}
