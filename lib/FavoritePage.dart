import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guitar_app/SheetPage.dart';
import 'package:guitar_app/models/chord_data.dart';

import 'package:provider/provider.dart';
import 'package:guitar_app/providers/LanguageProvider.dart';


class FavoritePage extends StatefulWidget {
  final Set<int> favoritedSheets;
  final List<String> sheets;
  final List<ChordData> chord_list;

  FavoritePage(this.favoritedSheets, this.sheets, this.chord_list);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  double _left = 50.0;
  double _top = 50.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startMovingText();
  }

  void _startMovingText() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final random = Random();
      if (mounted) {
        setState(() {
          _left = random.nextDouble() * (MediaQuery.of(context).size.width - 150);
          _top = random.nextDouble() * (MediaQuery.of(context).size.height - 150);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageprovider = Provider.of<Languageprovider>(context);

    // Filter sheets based on whether their indices are in favoritedSheets
    List<String> favorited = widget.sheets.asMap().entries
        .where((entry) => widget.favoritedSheets.contains(entry.key))
        .map((entry) => entry.value)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text((languageprovider.isChiFriendly) ? '最喜歡的和弦表<3' : 'Favorite Chord Sheet'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          if (favorited.isNotEmpty)
            ListView.separated(
              itemCount: favorited.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Theme.of(context).dividerColor),
              itemBuilder: (_, index) => ListTile(
                leading: Icon(Icons.music_note,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text(
                  favorited[index],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onBackground),
                onTap: () {
                  // Action to take when tapped
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => ChordChartPage(
                            chordData: widget.chord_list
                                .where((element) =>
                                    element.songName == favorited[index])
                                .toList()
                                .first,
                            name: favorited[index]
                      ),
                      transitionDuration: Duration(seconds: 1),
                      transitionsBuilder: (_, animation, __, child) {
                        var curve = Curves.elasticInOut;
                        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

                        return ScaleTransition(
                          scale: curvedAnimation,
                          child: FadeTransition(
                            opacity: curvedAnimation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                  print('Tapped on ${favorited[index]}');
                },
              ),
            )
          else
            TweenAnimationBuilder(
              tween: Tween<Offset>(
                begin: Offset(_left, _top),
                end: Offset(_left, _top),
              ),
              duration: Duration(seconds: 1),
              builder: (context, offset, child) {
                return Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: child!,
                );
              },
              onEnd: () {
                final random = Random();
                setState(() {
                  _left = random.nextDouble() *
                      (MediaQuery.of(context).size.width - 150);
                  _top = random.nextDouble() *
                      (MediaQuery.of(context).size.height - 150);
                });
              },
              child: Text(
                (languageprovider.isChiFriendly) ? 
                '還沒有新增最愛的歌單...\n還沒有新增最愛的歌單...\n還沒有新增最愛的歌單...\n' : 
                "No favorite there\nNo favorite there\nNo favorite there\n",
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 226, 165, 162).withOpacity(0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

