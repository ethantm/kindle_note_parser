import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Note extends Equatable {
  const Note({
    this.bookTitle = "",
    this.bookAuthor = "",
    this.location = "",
    this.text = ""
  });

  @HiveField(0)
  final String bookTitle;
  @HiveField(1)
  final String bookAuthor;
  @HiveField(2)
  final String location;
  @HiveField(3)
  final String text;

  @override
  List<Object?> get props => [
    bookTitle,
    bookAuthor,
    location,
    text
  ];

  Note copyWith({
    String? bookTitle,
    String? bookAuthor,
    String? location,
    String? text
  }) {
    return Note(
      bookTitle: bookTitle ?? this.bookTitle,
      bookAuthor: bookAuthor ?? this.bookAuthor,
      location: location ?? this.location,
      text: text ?? this.text
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}