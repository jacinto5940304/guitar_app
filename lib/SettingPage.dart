import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guitar_app/TutorialPage.dart';

import 'package:provider/provider.dart';
import 'package:guitar_app/providers/VolumeProvider.dart';
import 'package:guitar_app/providers/ThemeProvider.dart';
import 'package:guitar_app/providers/LanguageProvider.dart';


class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final volumeProvider = Provider.of<VolumeProvider>(context);
    final languageprovider = Provider.of<Languageprovider>(context);

    bool _darkModeEnabled = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: (languageprovider.isChiFriendly) ? Text('設定') : Text('Setting'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: (languageprovider.isChiFriendly) ? Text('中文友善功能') : Text('Chinese friendly'),
            subtitle: (languageprovider.isChiFriendly) ? Text('我們總是對華人友善:D') : Text('We are always with every families'),
            secondary: Icon(
              Icons.language_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: languageprovider.isChiFriendly,
            onChanged: (bool value) {
              setState(() {
                languageprovider.toggleFriendly(value);
              });
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          CheckboxListTile(
            title: (languageprovider.isChiFriendly) ? Text('暗黑模式') : Text('Enable Dark Mode'),
            subtitle: (languageprovider.isChiFriendly) ? Text('保護您的眼睛並節省電力') : Text('Reduce eye strain and save battery life.'),
            secondary: Icon(
              Icons.dark_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: _darkModeEnabled,
            onChanged: (bool? value) {
              setState(() {
                _darkModeEnabled = value ?? false;
                themeProvider.toggleTheme(_darkModeEnabled);
              });
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
          ListTile(
            leading: Icon(
              Icons.lightbulb,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: (languageprovider.isChiFriendly) ? Text('使用教學') : Text('Tutorial'),
            subtitle: (languageprovider.isChiFriendly) ? Text('第一次使用不緊張！讓我們教教你！') : Text('Let\'s learn how to use this app!.'),
            trailing: Icon(Icons.navigate_next, color: Theme.of(context).colorScheme.onBackground),
            onTap: () {
              // Navigate to tutorial page
              Navigator.push(
                context, 
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Tutorialpage(),
                  transitionDuration: Duration(seconds: 1),
                  transitionsBuilder: (_, animation, __, child) {
                    return Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Divider(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              (languageprovider.isChiFriendly) ? '音量控制' : 'Volume Control',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Slider(
            value: volumeProvider.volume,
            onChanged: (double value) {
              setState(() {
                volumeProvider.setVolume(value);
              });
            },
            min: 0,
            max: 1,
            divisions: 10,
            label: '${(volumeProvider.volume * 100).round()}%',
          ),
        ],
      ),
    );
  }

//   void _enableDarkMode() {
//     ThemeData darkTheme = ThemeData.dark().copyWith(
//       colorScheme: ColorScheme.dark(
//         primary: Colors.deepOrange,
//         secondary: Colors.amber,
//       ),
//       toggleableActiveColor: Colors.deepOrange,
//     );
//     setState(() {
//       Theme.of(context).copyWith(
//         primaryColor: Colors.deepOrange,
//         backgroundColor: Colors.black,
//       );
//     });
//   }

//   void _disableDarkMode() {
//     ThemeData lightTheme = ThemeData.light().copyWith(
//       colorScheme: ColorScheme.light(
//         primary: Colors.blue,
//         secondary: Colors.lightBlueAccent,
//       ),
//       toggleableActiveColor: Colors.blue,
//     );
//     setState(() {
//       Theme.of(context).copyWith(
//         primaryColor: Colors.blue,
//         backgroundColor: Colors.white,
//       );
//     });
//   }
}