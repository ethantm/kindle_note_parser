import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ListTile, Colors, FilledButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kindle_note_parser/settings/bloc/settings_bloc.dart';
import 'package:kindle_repository/kindle_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required KindleRepository kindleRepository})
      : _kindleRepository = kindleRepository,
        super(key: key);

  final KindleRepository _kindleRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          SettingsBloc bloc = SettingsBloc(_kindleRepository);
          bloc.add(SettingsInit());
          return bloc;
        },
        child: const Settings());
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.synced) {
          showSnackbar(
            context,
            InfoBar(
              title: const Text("Notes successfully synced!"),
              severity: InfoBarSeverity.success,
              onClose: () {
                context
                    .read<SettingsBloc>()
                    .add(SettingsSyncSuccessToggle());
              },
            )
          );
        }

        if (state.synced) {
          showSnackbar(
            context,
            InfoBar(
              title: const Text("Notes successfully exported!"),
              severity: InfoBarSeverity.success,
              onClose: () {
                context
                    .read<SettingsBloc>()
                    .add(SettingsExportSuccessToggle());
              },
            )
          );
        }
      },
      child: ScaffoldPage(
          content: Container(
              padding: const EdgeInsets.only(left: 100),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: BlocBuilder<SettingsBloc, SettingsState>(
                          builder: (context, state) {
                        return ListView(
                            children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text("Detected Kindle Devices",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge)),
                                ] +
                                state.kindleDrives.map((drive) {
                                  return ListTile.selectable(
                                    title: Text("$drive KINDLE"),
                                    selected: state.selectedDrive == drive,
                                    onPressed: () {
                                      context.read<SettingsBloc>().add(
                                          SettingsKindleSelected(
                                              kindleDrive: drive));
                                    },
                                  );
                                }).toList() +
                                [
                                  Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Button(
                                      child: const Text("Refresh devices"),
                                      onPressed: () {
                                        context
                                            .read<SettingsBloc>()
                                            .add(SettingsInit());
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 50),
                                    child: FilledButton(
                                      child: const Text("Sync notes"),
                                      onPressed: () {
                                        context
                                            .read<SettingsBloc>()
                                            .add(SettingsSyncNotes());
                                      },
                                    ),
                                  ),
                                ]);
                      }),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Text("Export notes",
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          SizedBox(
                              width: 400,
                              height: 400,
                              child: BlocBuilder<SettingsBloc, SettingsState>(
                                builder: (context, state) {
                                  return ListView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      children: state.booksList.map((book) {
                                        return ListTile.selectable(
                                          title: Text(book),
                                          selected: state.selectedBooks
                                              .contains(book),
                                          selectionMode:
                                              ListTileSelectionMode.multiple,
                                          onPressed: () {
                                            context.read<SettingsBloc>().add(
                                                SettingsToggleBook(book: book));
                                          },
                                        );
                                      }).toList());
                                },
                              )),
                          Container(
                            width: 300,
                            margin: const EdgeInsets.only(top: 20),
                            child: Button(
                              child: const Text("Export selected"),
                              onPressed: () {
                                context.read<SettingsBloc>().add(
                                    SettingsExportBooks(
                                        books: context
                                            .read<SettingsBloc>()
                                            .state
                                            .selectedBooks));
                              },
                            ),
                          ),
                          Container(
                            width: 300,
                            margin: const EdgeInsets.only(top: 10),
                            child: FilledButton(
                              child: const Text("Export all"),
                              onPressed: () {
                                context.read<SettingsBloc>().add(
                                    SettingsExportBooks(
                                        books: context
                                            .read<SettingsBloc>()
                                            .state
                                            .booksList));
                              },
                            ),
                          ),
                        ]),
                  ]))),
    );
  }
}
