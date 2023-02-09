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

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
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
          pane: NavigationPane(
            selected: 1,
            displayMode: PaneDisplayMode.top,
            onChanged: (value) {
              print(value);
            },
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.sticky_notes_outline_app_icon),
                body: const Text("My Notes"),
                onTap: () {
                }),
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                body: const SettingsPage(),
                onTap: () {
                  // Navigator.of(context).push(Settings.route());
                })
            ]
          ),
        ));
  }
}