import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'note.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends Equatable {
  const Book({
    required this.title,
    required this.author,
    required this.notes
  });

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final List<Note> notes;

  @override
  String toString() {
    return "$title by $author";
  }

  @override
  List<Object?> get props => [
    title,
    author,
    notes
  ];

  Book copyWith({
    String? title,
    String? author,
    List<Note>? notes
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      notes: notes ?? this.notes
    );
  }
}