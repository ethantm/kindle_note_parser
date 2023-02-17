part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class NotesGetNotes extends NotesEvent {}

class NotesBookSelected extends NotesEvent {
  const NotesBookSelected({required this.bookTitle, required this.notes});

  final String bookTitle;
  final List<Note> notes;
}