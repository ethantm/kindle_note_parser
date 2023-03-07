import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kindle_repository/kindle_repository.dart';
import 'package:kindle_repository/models/models.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final KindleRepository _kindleRepository;

  NotesBloc(KindleRepository kindleRepository)
      : _kindleRepository = kindleRepository,
        super(const NotesState()) {
    on<NotesGetNotes>((event, emit) async {
      Map<String, List<Note>> books = _kindleRepository.getBooks();

      if (books.isEmpty) {
        return;
      }

      String first = books.keys.first;

      emit(state.copyWith(
          books: books, selectedBook: first, selectedNotes: books[first]));
    });

    on<NotesBookSelected>((event, emit) {
      emit(state.copyWith(
          selectedBook: event.bookTitle, selectedNotes: event.notes));
    });

    on<NotesSearch>((event, emit) {
      List<Note> newNotes = [];

      if (event.search.isEmpty) {
        emit(state.copyWith(selectedNotes: state.books[state.selectedBook]!));
        return;
      }

      for (Note note in state.selectedNotes) {
        if (note.text.toLowerCase().contains(event.search.toLowerCase())) {
          newNotes.add(note);
        }
      }

      emit(state.copyWith(selectedNotes: newNotes));
    });
  }
}
