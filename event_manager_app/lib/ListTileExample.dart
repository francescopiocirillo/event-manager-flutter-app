import 'package:flutter/material.dart';

class ListTileExample extends StatefulWidget {
  const ListTileExample({super.key});

  @override
  State<ListTileExample> createState() => _ListTileExampleState();
}

class _ListTileExampleState extends State<ListTileExample> {
  ListTileTitleAlignment? titleAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Divider(),
          ListTile(
            titleAlignment: titleAlignment,
            leading: Checkbox(
              value: true,
              onChanged: (bool? value) {},
            ),
            title: const Text('Headline Text'),
            subtitle: const Text(
                'Tapping on the trailing widget will show a menu that allows you to change the title alignment. The title alignment is set to threeLine by default if `ThemeData.useMaterial3` is true. Otherwise, defaults to titleHeight.'),
            trailing: PopupMenuButton<ListTileTitleAlignment>(
              onSelected: (ListTileTitleAlignment? value) {
                setState(() {
                  titleAlignment = value;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ListTileTitleAlignment>>[
                const PopupMenuItem<ListTileTitleAlignment>(
                  value: ListTileTitleAlignment.threeLine,
                  child: Text('threeLine'),
                ),
                const PopupMenuItem<ListTileTitleAlignment>(
                  value: ListTileTitleAlignment.titleHeight,
                  child: Text('titleHeight'),
                ),
                const PopupMenuItem<ListTileTitleAlignment>(
                  value: ListTileTitleAlignment.top,
                  child: Text('top'),
                ),
                const PopupMenuItem<ListTileTitleAlignment>(
                  value: ListTileTitleAlignment.center,
                  child: Text('center'),
                ),
                const PopupMenuItem<ListTileTitleAlignment>(
                  value: ListTileTitleAlignment.bottom,
                  child: Text('bottom'),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
