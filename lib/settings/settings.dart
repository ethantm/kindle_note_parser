import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ListTile, Colors, FilledButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kindle_note_parser/settings/bloc/settings_bloc.dart';
import 'package:kindle_repository/kindle_repository.dart';

class SettingsPage extends StatelessWidget {
const SettingsPage({Key? key, required KindleRepository kindleRepository}) : 
  _kindleRepository = kindleRepository, 
  super(key: key);

  final KindleRepository _kindleRepository;

  @override
  Widget build(BuildContext context){
    return BlocProvider(create: (context) { 
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
    return ScaffoldPage(
      content: Container(
        padding: const EdgeInsets.only(left: 100),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
                return ListView(
                  children: 
                  <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text("Detected Kindle Devices", style: Theme.of(context).textTheme.titleLarge)),
                  ] +
                  state.kindleDrives.map((drive) {
                    return ListTile.selectable(
                      title: Text("$drive KINDLE"),
                      selected: state.selectedDrive == drive,
                      onPressed: () {
                        context.read<SettingsBloc>().add(SettingsKindleSelected(kindleDrive: drive));
                      },
                    );
                  }).toList() +
                  [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Button(
                        child: const Text("Refresh devices"),
                        onPressed: () {
                          context.read<SettingsBloc>().add(SettingsInit());
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: FilledButton(
                        child: const Text("Sync notes"),
                        onPressed: () {
                          context.read<SettingsBloc>().add(SettingsSyncNotes());
                        },
                      ),
                    ),
                  ]
                );
              }),
            ),
            // Expanded(
            //   child: ListView(
            //     children: [
            //       ListTile(
            //         title: Text("Settings, second column"),
            //         subtitle: Text("Configure the app"),
            //       ),
            //     ]
            //   )
            // ),
          ]
        )
      )
    );
  }
}
