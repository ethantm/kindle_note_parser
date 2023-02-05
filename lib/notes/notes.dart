import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide ListTile, Colors;

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: 200,
                  child: ListView(
                    children: [
                      ListTile.selectable(
                        title: Text("Courage is calling"),
                        subtitle: Text("Ryan Holiday"),
                        selected: true,
                        onPressed: () {},
                      )
                    ],
                  )),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 100),
                      child: ListView(children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Text("Courage is calling",
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                        ListTile(
                          tileColor:
                              ButtonState.all(Colors.grey.withOpacity(0.1)),
                          title: Text("Loc 2807 - You Must Burn the White Flag",
                              style: Theme.of(context).textTheme.labelMedium),
                          subtitle: Text(
                              "The one who won't ever quit will be the winner, if not now, then later, if not in this life, then in the next.",
                              style: Theme.of(context).textTheme.bodyLarge),
                        )
                      ]))),
            ],
          )),
    );
  }
}
