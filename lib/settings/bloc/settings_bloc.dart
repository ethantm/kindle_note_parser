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
      List<String> booksList = _kindleRepository.getBooksList();

      emit(state.copyWith(kindleDrives: kindles, booksList: booksList));
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

    on<SettingsToggleBook>(((event, emit) {
      List<String> newSelectedBooks = List.from(state.selectedBooks);

      if (newSelectedBooks.contains(event.book)) {
        newSelectedBooks.remove(event.book);
      } else {
        newSelectedBooks.add(event.book);
      }

      emit(state.copyWith(selectedBooks: newSelectedBooks));
    }));

    on<SettingsExportBooks>((event, emit) async {
      List<String> booksList = event.books;
      List<Book> books = _kindleRepository.getBooksFromList(booksList);
      await _kindleRepository.exportPdfBook(books.first);
    });
  }
}
