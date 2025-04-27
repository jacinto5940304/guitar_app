// import 'dart:html';
// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


// page
import 'package:guitar_app/FavoritePage.dart';
import 'package:guitar_app/InformationPage.dart';
import 'package:guitar_app/SettingPage.dart';
import 'package:guitar_app/SheetPage.dart';


// AI
import 'package:guitar_app/models/chat_message.dart';
import 'package:guitar_app/models/chord_data.dart';
// import 'package:guitar_app/services/assistant.dart';
import 'package:guitar_app/services/chat.dart';


// player
import 'package:url_launcher/url_launcher.dart';

// provider
import 'package:provider/provider.dart';
import 'package:guitar_app/providers/ThemeProvider.dart';
import 'package:guitar_app/providers/VolumeProvider.dart';
import 'package:guitar_app/providers/LanguageProvider.dart';




void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => VolumeProvider()),
        ChangeNotifierProvider(create: (_) => Languageprovider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    // define the colors
    const Color primaryColor = Color(0xFF7E5700);
    const Color secondaryColor = Color(0xFF6E5C40);
    const Color tertiaryColor = Color(0xFF715C00);
    // const Color errorColor = Color(0xFFBA1A1A);
    const Color backgroundColor = Color(0xFFFFFBFF);
    // const Color secondxaryContainer = Color(0xFFf8dfbb); 


    return MaterialApp(
      title: 'guitar_app',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          brightness: Brightness.light,
          primary: Color(0xFF7E5700),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFDEAC),
          onPrimaryContainer: Color(0xFF281900),
          secondary: Color(0xFF6E5C40),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFF8DFBB),
          onSecondaryContainer: Color(0xFF261904),
          tertiary: Color(0xFF715C00),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFE17A),
          onTertiaryContainer: Color(0xFF231B00),
          error: Color(0xFFBA1A1A),
          errorContainer: Color(0xFFFFDAD6),
          onError: Color(0xFFFFFFFF),
          onErrorContainer: Color(0xFF410002),
          background: Color(0xFFFFFBFF),
          onBackground: Color(0xFF1F1B16),
          surface: Color(0xFFFFFBFF),
          onSurface: Color(0xFF1F1B16),
          surfaceVariant: Color(0xFFEFE0CF),
          onSurfaceVariant: Color(0xFF4E4539), 
          outline: Color(0xFF807567),
          onInverseSurface: Color(0xFFF8EFE7),
          inverseSurface: Color(0xFF34302A),
          inversePrimary: Color(0xFFFBBB49),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF7E5700),
          outlineVariant: Color(0xFFD2C4B4),
          scrim: Color(0xFF000000),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white, // Ensures contrast text color
        ),
        scaffoldBackgroundColor: backgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(secondaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        // Any other specific theme adjustments you need
        popupMenuTheme: const PopupMenuThemeData(
          color: tertiaryColor,
          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF7E5700),
        colorScheme: ColorScheme.dark().copyWith(
          primary: Color(0xFF7E5700),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF4E342E),
          onPrimaryContainer: Color(0xFFFFDEAC),
          secondary: Color(0xFF6E5C40),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFF3E2723),
          onSecondaryContainer: Color(0xFFF8DFBB),
          tertiary: Color(0xFF715C00),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFF4E342E),
          onTertiaryContainer: Color(0xFFFFE17A),
          error: Color(0xFFCF6679),
          errorContainer: Color(0xFF370B1E),
          onError: Color(0xFF1C1B1F),
          onErrorContainer: Color(0xFFFFDAD6),
          background: Color(0xFF121212),
          onBackground: Color(0xFFE1E1E1),
          surface: Color(0xFF121212),
          onSurface: Color(0xFFE1E1E1),
          surfaceVariant: Color(0xFF4E342E),
          onSurfaceVariant: Color(0xFFEFE0CF),
          outline: Color(0xFF807567),
          onInverseSurface: Color(0xFF121212),
          inverseSurface: Color(0xFFE1E1E1),
          inversePrimary: Color(0xFFFBBB49),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF7E5700),
          outlineVariant: Color(0xFFD2C4B4),
          scrim: Color(0xFF000000),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7E5700),
          foregroundColor: Colors.white, // Ensures contrast text color
        ),
        scaffoldBackgroundColor: Color(0xFF121212),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF6E5C40)),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFF715C00),
          textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // TODO 
  final TextEditingController _textController = TextEditingController();

  final ChatService _songInfoService = ChatService();
  final ChatService _chordGenerator = ChatService();

  List<ChatMessage> songInfoMessages = [];
  List<ChatMessage> chordMessages = [];
  List<ChordData> chordList = [];

  bool _isLoading = false;

  String _songType = "original";
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _songInfoService.fetchMessages();
    _chordGenerator.fetchMessages();

    _songInfoService.messagesStream.listen((messages) {
      setState(() {
        songInfoMessages = messages.where((message) => message.role == 'assistant').toList();
      });
    });

      _chordGenerator.messagesStream.listen((messages) {
      setState(() {
        chordMessages = messages.where((message) => message.role == 'assistant').toList();
      });
    });
  }


  final List<String> _sheets = [];
  // final List<String> _favorite_sheets = [];
  Set<int> _favoritedSheets = <int>{};


  void _removeSongInfoMessage(String data) {
    setState(() {
      songInfoMessages.removeWhere((message) => message.text.split('\n').contains(data));
    });
  }


  void _addItem(String name) {
    // _isSelected = false;
    setState(() {
      _sheets.add(name);
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoritedSheets.contains(index)) {
        _favoritedSheets.remove(index);
      } else {
        _favoritedSheets.add(index);
      }
    });
  }

  void _removeSheet(int index, bool isChi) {
    // TODO
    ChordData delete_chord = chordList[index];
    
    String delete_sheet = _sheets[index];
    setState(() {
      //
      chordList.removeAt(index);
      _favoritedSheets.remove(index);
      _favoritedSheets = _favoritedSheets.map((idx) => (idx >= index) ? idx-1 : idx).toSet();
      _sheets.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text((isChi) ? '刪除譜面' : 'Sheet Deleted.'),
        action: SnackBarAction(
          backgroundColor: Theme.of(context).colorScheme.onError.withOpacity(0.5),
          textColor: Theme.of(context).colorScheme.onError,
          label: (isChi) ? '取消動作' : 'Undo',
          onPressed: () {
            setState(() {
              _sheets.insert(index, delete_sheet);
              chordList.insert(index, delete_chord);

              _favoritedSheets = _favoritedSheets.map((idx) => (idx >= index) ? idx+1 : idx).toSet();
          });
          },
        ),
      ),
    );
  }

  void _sendPrompt() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _songInfoService.clearMessages(); // 清空之前的聊天记录
      });
      if(_songType != 'original'){
        _songInfoService.fetchPromptResponse("Please only give me a list of several versions of ${_textController.text.trim()} in only ${_songType} genre in the format of \"song name - artist name\" without other description. (如果是中文字請用繁體字)(如果找不到請直接輸出\"error\")");
      } 
      else {
        _songInfoService.fetchPromptResponse("Please give the original version of ${_textController.text.trim()} in the format of \"song name - artist name\" without other description. (如果是中文字請用繁體字)(如果找不到請直接輸出\"error\")");
      }
      _textController.clear();
    }
  }

  void _dragAndGenerate(String song_name) async {
    setState(() {
      _chordGenerator.clearMessages(); // 清空之前的和弦資料
      _isLoading = true;
    });
    await _chordGenerator.fetchPromptResponse("please give me the full song's chord progression of \"${_textController.text.trim()}\" in csv format within one string without newline and excess words and descriptions and lyrics, for example, adding \"sure, .. \" is prohibited, and please don't give me information like 'chorus' , 'verse' , etc.... Please output only chord, 也不用上下引號把output括起來... ps. 盡量避免有升降記號");
    final latestResponse = _chordGenerator.messages.firstWhere((message) => message.role == 'assistant').text;

    setState(() {

      ChordData newChordData = ChordData(songName: song_name, chord_csv: latestResponse);
      chordList.add(newChordData);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageprovider = Provider.of<Languageprovider>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          (languageprovider.isChiFriendly) ? '自動產弦軟件' : 'Guitar Chord APP',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.outline,
        toolbarHeight: 80.0,  // Adjusted AppBar height
        leading: PopupMenuButton<String>(
          color: Theme.of(context).colorScheme.secondaryContainer,
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),  // Changed icon to a menu icon

          onSelected: (String result) {
            switch (result) {
              case 'page1':
                Navigator.push(
                  context,
                  // Fixed
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FavoritePage(_favoritedSheets, _sheets, chordList),
                    transitionDuration: Duration(seconds: 1),
                    transitionsBuilder: (_, animation, __, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                  
                  // MaterialPageRoute(builder: (context) => Home(),)

                );
                break;
              case 'page2':
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => SettingPage(),
                    transitionDuration: Duration(seconds: 1),
                    transitionsBuilder: (_, animation, __, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
                break;
              case 'page3':
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => InformationPage(),
                    transitionDuration: Duration(seconds: 1),
                    transitionsBuilder: (_, animation, __, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
                break;
            }
          },

          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[

            PopupMenuItem<String>(
              value: 'page1',
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Padding inside each menu item
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.outline,
                      size: 20.0,
                    ),
                    Text(
                      (languageprovider.isChiFriendly) ? '  喜歡的歌' : '  Favorite songs',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondaryContainer, // Text color for PopupMenuItem
                        fontWeight: FontWeight.bold, // Font weight for PopupMenuItem
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'page2',
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Padding inside each menu item
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.outline,
                      size: 20.0,
                    ),
                    Text(
                      (languageprovider.isChiFriendly) ? '  設定與教學' : '  Setting & tutorial',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondaryContainer, // Text color for PopupMenuItem
                        fontWeight: FontWeight.bold, // Font weight for PopupMenuItem
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'page3',
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Padding inside each menu item
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Theme.of(context).colorScheme.outline,
                      size: 20.0,
                    ),
                    Text(
                      (languageprovider.isChiFriendly) ? '  其他資訊' : '  Other information',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondaryContainer, // Text color for PopupMenuItem
                        fontWeight: FontWeight.bold, // Font weight for PopupMenuItem
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(flex: 1,),

          // list the song we might choosec
          Expanded(
            flex: 5,
            child: SongInfoList(languageprovider.isChiFriendly),
          ),

          // prompt for entering the song name
          TextArea(context, languageprovider.isChiFriendly),

          // generated chord list
          Flexible(
            flex: 4,
            child: DragTarget<String>(
              builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected,) => 
                Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: _sheets.isNotEmpty ? SheetList(context, languageprovider.isChiFriendly) : 
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: (_isDragging) ? 
                      Text(
                        (languageprovider.isChiFriendly) ? '拖曳歌曲於此處' :"drag the song to this area...",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ) : 
                      Text((languageprovider.isChiFriendly) ? '這裡還沒有和弦...' : "No chord there",
                      ),
                    ),
                  ),
                ),
              // TODO
              onAcceptWithDetails: (details) {
                _addItem(details.data);
                _removeSongInfoMessage(details.data);
                _dragAndGenerate(details.data);

              },
              onWillAcceptWithDetails: (details) {
                if(_sheets.contains(details.data)){
                  return false;
                }
                else{
                  return true;
                }
              },
            ) 
          ),


        ],
      ),
    );
  }


  StreamBuilder<List<ChatMessage>> SongInfoList(bool isChi) {
    return StreamBuilder<List<ChatMessage>>(
            stream: _songInfoService.messagesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {

                // TODO
                if (songInfoMessages.isEmpty) {
                  songInfoMessages = snapshot.data!
                      .where((message) => message.role == 'assistant')
                      .toList();
                }
                if(songInfoMessages.isEmpty || songInfoMessages[0].text.contains('error') || songInfoMessages[0].text.contains('Error') || songInfoMessages[0].text.contains('ERROR')){
                  return Center(child: Text((isChi) ? '錯誤： 找不到這首歌ＱＱ' : 'Error: the song is not found'));
                }  
                
                return ListView.builder(
                  reverse: true,
                  itemCount: songInfoMessages.length + 1, // one extra for padding
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(height: 16);
                    }
                    // TODO
                    if (index - 1 >= songInfoMessages.length){
                      return Container();
                    }

                    final message = songInfoMessages[index - 1];
                    final lines = message.text.split('\n');

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: lines.map((line) {
                        return Row(
                          children: [
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0,),
                              child: Draggable<String>(
                                data: line,
                            
                                // TODO
                                onDragStarted: () {
                                  setState(() {
                                    _isDragging = true;
                                  });
                                },
                                onDragEnd: (details) {
                                  setState(() {
                                    _isDragging = false;
                                  });
                                },
                                // dragging
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 30),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        //
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(16),
                                        alignment: Alignment.centerLeft,
                                        shadowColor: Colors.transparent, // 去除陰影
                                      ),
                                      child: Text(
                                        line,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // undragging
                                childWhenDragging: Container(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      launch("https://www.youtube.com/results?search_query=${line}");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(16),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    child: Text(
                                      line,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                );
              } else {
                return Center(
                    child: Text((isChi) ? '輸入歌名取得你要的和弦！' : 'Enter a song\'s name to get the chord!'));
              }
            },
          );
  }

  Container TextArea(BuildContext context, bool isChi) {
    return Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration:
                      InputDecoration(hintText: (isChi) ? '輸入歌曲名稱' : 'Enter your song'),
                  maxLines: null, // Allows input to expand
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: _songType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _songType = newValue!;
                      });
                    },
                    items: <String>['original', 'rock', 'romantic', 'classic', 'jazz', 'blue', 'R&B']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: _sendPrompt,
                child: Text((isChi) ? '傳送' :'Send'),
              ),
            ],
          ),
        );
  }

  // ignore: non_constant_identifier_names
  Widget SheetList(BuildContext context, bool isChi) {

    if(!_isLoading){
       return ListView.builder(
              itemCount: _sheets.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Dismissible(
                  key: ValueKey(_sheets[index]),
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    margin: EdgeInsets.symmetric(
                      horizontal: Theme.of(context).cardTheme.margin?.horizontal ?? 15.0, // Safe fallback
                    ),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete, color: Colors.white)

                    // margin: EdgeInsets.symmetric(
                    //   horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                    // ),
                  ),
                  onDismissed: (dir){
                    _removeSheet(index, isChi);
                  },

                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20, bottom: 5),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _toggleFavorite(index),
                          icon: Icon(
                            _favoritedSheets.contains(index) ? Icons.favorite : Icons.favorite_border,
                            color: Theme.of(context).colorScheme.outline,
                            size: 34.0,
                            semanticLabel: 'record the sound',
                          ),
                        ),
                        const SizedBox(width: 20), // Spacing between the icon and text
                        Expanded(
                          child: GestureDetector(
                            onTap: (){

                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => ChordChartPage(chordData: chordList[index], name: _sheets[index]),
                                  transitionDuration: const Duration(seconds: 1),
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
                            },
                          
                            child: Text(
                              _sheets[index], 
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
    }  
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator()),
        SizedBox(height: 3.0,),
        Text("Loading..."),
      ],
    );
  }

}






// cd /path/to/your/project
// git init
// git add .
// git commit -m "Your commit message"
// git push -u origin main

