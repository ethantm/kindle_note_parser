import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ListTile, Colors, IconButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kindle_note_parser/notes/bloc/notes_bloc.dart';
import 'package:kindle_repository/kindle_repository.dart';
import 'package:kindle_repository/models/models.dart';
import 'package:flutter/services.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({Key? key, required KindleRepository kindleRepository}) : 
    _kindleRepository = kindleRepository,
    super(key: key);

  final KindleRepository _kindleRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      NotesBloc bloc = NotesBloc(_kindleRepository);
      bloc.add(NotesGetNotes());
      return bloc;
    }, 
    child: const Notes());
  }
}

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 400,
                child: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      itemCount: state.books.values.length,
                      itemBuilder: (context, index) {
                        String key = state.books.keys.elementAt(index);
                        List<Note> book = state.books[key]!;
                        return ListTile.selectable(
                          title: Text(book[0].bookTitle),
                          subtitle: Text(book[0].bookAuthor),
                          selected: state.selectedBook == book[0].bookTitle,
                          onPressed: () {
                            context.read<NotesBloc>().add(
                              NotesBookSelected(bookTitle: book[0].bookTitle, notes: book)
                            );
                          },
                        );
                    });
                  }
                ),
              ),
              Expanded(
                  child: BlocBuilder<NotesBloc, NotesState>(
                    builder: (context, state) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Text(state.selectedBook,
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                        ] +
                        state.selectedNotes.map((note) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: ListTile(
                              tileColor:
                                  ButtonState.all(Colors.grey.withOpacity(0.1)),
                              title: Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Location ${note.location}", 
                                      style: Theme.of(context).textTheme.labelMedium, 
                                      textAlign: TextAlign.left,),
                                    IconButton(onPressed: () {
                                      Clipboard.setData(ClipboardData(text: note.text));
                                    }, icon: const Icon(FluentIcons.copy)),
                                    Text("Note ${state.selectedNotes.indexOf(note) + 1} of ${state.selectedNotes.length}", 
                                      style: Theme.of(context).textTheme.labelMedium, 
                                      textAlign: TextAlign.right,),
                                  ]
                                ),
                              ),
                              subtitle: Container(
                                margin: const EdgeInsets.only(bottom: 10, top: 15),
                                child: SelectableText(
                                  note.text,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              )
                            ),
                          );
                        }).toList()
                      );
                    }
                  )
                ),
            ],
          )),
    );
  }
}