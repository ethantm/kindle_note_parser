import 'dart:ui';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';
import 'package:kindle_note_parser/notes/notes.dart';
import 'package:kindle_note_parser/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
      size: Size(800, 600),
      title: "Kindle Note Parser",
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.normal);

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
        theme: ThemeData(
          brightness: Brightness.light,
          accentColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.compact,
        ),
        themeMode: ThemeMode.light,
        title: "Kindle Note Parser",
        home: NavigationView(
          appBar: NavigationAppBar(
              automaticallyImplyLeading: false,
              actions: Container(
                margin: const EdgeInsets.only(left: 20, top: 20),
                child: CommandBar(
                  primaryItems: [
                    CommandBarButton(
                      icon:
                          const Icon(FluentIcons.sticky_notes_outline_app_icon),
                      label: const Text("My Notes"),
                      onPressed: () {
                        // Navigator.push(context, Notes.route());
                      },
                    ),
                    CommandBarButton(
                      icon: const Icon(FluentIcons.settings),
                      label: const Text("Settings"),
                      onPressed: () {},
                    ),
                  ],
                ),
              )),
          content: Notes(),
        ));
  }
}
