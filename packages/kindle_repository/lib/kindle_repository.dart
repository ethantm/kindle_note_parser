library kindle_repository;

import 'package:kindle_repository/models/models.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'dart:io';

class KindleRepository {
  KindleRepository();

  late Box booksBox;

  Future<void> initStorage() async {
    String path = Directory.current.path;
    Hive
      ..init(path)
      ..registerAdapter(BookAdapter())
      ..registerAdapter(NoteAdapter());
    booksBox = await Hive.openBox("books");
  }

  void storeNotes(Map<String, List<Note>> notes) {
    for (var book in notes.keys) {
      Note note = notes[book]![0];

      if (booksBox.containsKey(book)) {
        if (booksBox.get(book).notes.length == notes[book]!.length) {
          continue;
        }
      }

      Book temp = Book(
          title: note.bookTitle, author: note.bookAuthor, notes: notes[book]!);

      booksBox.put(note.bookTitle, temp);
    }
  }

  List<String> getBooksList() {
    List<String> books = [];
    for (String key in booksBox.keys) {
      books.add(key);
    }
    return books;
  }

  List<Book> getBooksFromList(List<String> booksList) {
    List<Book> books = [];
    for (String bookTitle in booksList) {
      books.add(booksBox.get(bookTitle));
    }
    return books;
  }

  Map<String, List<Note>> getBooks() {
    Map<String, List<Note>> books = {};
    for (String key in booksBox.keys) {
      books[key] = booksBox.get(key).notes;
    }

    return books;
  }

  List<String> getKindles() {
    ProcessResult process =
        Process.runSync("wmic", ["logicaldisk", "get", "Name", ",VolumeName"]);
    String out = process.stdout as String;
    List<String> outList = out.split("\r\n");

    List<String> kindleDrives = [];
    for (var line in outList) {
      if (line.toLowerCase().contains("kindle")) {
        kindleDrives.add(line.split(" ")[0]);
      }
    }

    return kindleDrives;
  }

  Future<List<String>> getNotesFromFile(String drive) async {
    File notes = File("$drive\\documents\\My Clippings.txt");

    if (await notes.exists()) {
      List<String> notesList = await notes.readAsLines();
      return notesList;
    } else {
      throw Exception("Notes file not found");
    }
  }

  Map<String, List<Note>> parseNotes(List<String> rawNotes) {
    List<String> note = [];
    Map<String, List<Note>> books = {};

    for (String line in rawNotes) {
      if (line == "==========") {
        Note parsedNote = parseNote(note);
        note = [];

        if (parsedNote.text.isEmpty) {
          continue;
        }

        if (books.containsKey(parsedNote.bookTitle)) {
          books[parsedNote.bookTitle]!.add(parsedNote);
        } else {
          books[parsedNote.bookTitle] = [parsedNote];
        }
      } else {
        note.add(line);
      }
    }

    return books;
  }

  Note parseNote(List<String> rawNote) {
    if (rawNote.length != 4) {
      throw Exception("Invalid note");
    }

    List<String> line1 = rawNote[0].split("(");
    String bookTitle = line1[0].trim();
    String bookAuthor = line1[1].split(")")[0];

    List<String> line2 = [];
    if (rawNote[1].contains("Location")) {
      line2 = rawNote[1].split("Location");
    } else {
      line2 = rawNote[1].split("page");
    }

    String location = line2[1].split("|")[0].trim();

    return Note(
        bookTitle: bookTitle,
        bookAuthor: bookAuthor,
        location: location,
        text: rawNote[3]);
  }

  Future<void> exportPdfBook(Book books) async {
    final pw.Document pdf = pw.Document();

    pw.Page page = pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.ListView(
            children: <pw.Widget>[
                  pw.Text(books.title, style: const pw.TextStyle(fontSize: 20)),
                  pw.Text(books.author),
                ] +
                books.notes.map((note) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Text("Location ${note.location}",
                            style: const pw.TextStyle(font: fontSize: 15)),
                        pw.Text(
                            "Note ${books.notes.indexOf(note)} of ${books.notes.length}",
                            style: const pw.TextStyle(fontSize: 15)),
                        pw.Text(note.text),
                      ],
                    ),
                  );
                }).toList(),
          );
        });

    pdf.addPage(page);

    final File file = File("${books.title}.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}
