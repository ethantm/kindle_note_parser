import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';
import 'package:kindle_note_parser/notes/notes.dart';
import 'package:kindle_note_parser/settings/settings.dart';
import 'package:kindle_repository/kindle_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
      size: Size(1200, 700),
      title: "Kindle Note Parser",
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.normal);

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  KindleRepository kindleRepository = KindleRepository();
  await kindleRepository.initStorage();
  runApp(Main(kindleRepository: kindleRepository));
}

class Main extends StatefulWidget {
  Main({Key? key, required KindleRepository kindleRepository}) : _kindleRepository = kindleRepository, super(key: key);

  final KindleRepository _kindleRepository;
  int selectedPane = 0;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget._kindleRepository,
      child: FluentApp(
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
              selected: widget.selectedPane,
              displayMode: PaneDisplayMode.top,
              items: [
                PaneItem(
                  icon: const Icon(FluentIcons.sticky_notes_outline_app_icon),
                  title: const Text("My Notes"),
                  body: NotesPage(kindleRepository: widget._kindleRepository,),
                  onTap: () {
                    setState(() {
                      widget.selectedPane = 0;
                    });
                  },
                  ),
                PaneItem(
                  icon: const Icon(FluentIcons.settings),
                  title: const Text("Settings"),
                  body: SettingsPage(kindleRepository: widget._kindleRepository),
                  onTap: () {
                    setState(() {
                      widget.selectedPane = 1;
                    });
                  }
                )
              ]
            ),
          )
          ),
    );
  }
}