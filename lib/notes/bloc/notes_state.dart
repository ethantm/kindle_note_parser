part of 'notes_bloc.dart';

class NotesState extends Equatable {
  const NotesState({
    this.books = const {},
    this.selectedBook = "",
    this.selectedNotes = const []
  });
  
  final Map<String, List<Note>> books;
  final String selectedBook;
  final List<Note> selectedNotes;

  @override
  List<Object> get props => [
    books,
    selectedBook,
    selectedNotes
  ];

  NotesState copyWith({
    Map<String, List<Note>>? books,
    String? selectedBook,
    List<Note>? selectedNotes
  }) {
    return NotesState(
      books: books ?? this.books,
      selectedBook: selectedBook ?? this.selectedBook,
      selectedNotes: selectedNotes ?? this.selectedNotes
    );
  }
}