import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ListTile, Colors;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kindle_note_parser/settings/bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
const SettingsPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BlocProvider(create: (context) => SettingsBloc(),
    child: const Settings());
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Container(
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text("Detected Kindle Devices", style: Theme.of(context).textTheme.titleLarge)),
                  ListTile.selectable(
                    title: const Text("Settings, first column"),
                    // subtitle: Text("Configure the app"),
                    onPressed: () {
                    },
                  ),
                  ListTile.selectable(
                    title: const Text("Settings, first column"),
                    // subtitle: Text("Configure the app"),
                    onPressed: () {
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Button(
                      child: const Text("Sync notes"),
                      onPressed: () {
                        // BlocProvider.of<SettingsBloc>(context).add(SettingsSyncNotes());
                        context.read<SettingsBloc>().add(SettingsSyncNotes());
                      },
                    ),
                  ),
                ]
              )
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Settings, second column"),
                    subtitle: Text("Configure the app"),
                  ),
                ]
              )
            ),
          ]
        )
      )
    );
  }
}
