import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guitar_app/models/chord_data.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:provider/provider.dart';
import 'package:guitar_app/providers/VolumeProvider.dart';
import 'package:guitar_app/providers/LanguageProvider.dart';
import 'dart:async';




class SongChord {
  const SongChord({
    required this.name,
    required this.chords,
  });

  final String name;
  final List<Chord> chords;
}

class Chord {
  Chord({
    required this.name,
    this.position = '1',
  });

  String name;
  String position;
}

final Map<String, SongChord> chordMap = {};


class ChordChartPage extends StatefulWidget {
  const ChordChartPage({
    super.key,
    required this.name,
    required this.chordData,
  });

  final String name;
  final ChordData chordData;

  @override
  _ChordChartPageState createState() => _ChordChartPageState();
}

class _ChordChartPageState extends State<ChordChartPage> {
  final List<String> allChords = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final Map<String, List<String>> chordVariants = {
    'A': ['', '7', 'm', 'm7', 'maj7'],
    'B': ['', '7', 'm', 'm7', 'm7-5'],
    'C': ['', '7', 'm', 'm7', 'm7-5', 'add9'],
    'D': ['', '7', 'm', 'm7', 'sus2', 'sus4'],
    'E': ['', '7', 'm', 'm7'],
    'F': ['', '7', 'm', 'm7', 'maj7'],
    'G': ['', '_B', '7', 'm', 'm7'],
  };

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _audioPlayerDa = AudioPlayer();
  final AudioPlayer _audioPlayerT = AudioPlayer();
  final AudioPlayer _audioPlayerDon = AudioPlayer();
  final TextEditingController _bpmController = TextEditingController();
  int _bpm = 75; // Default BPM
  bool isPlaying = false;
  int current_playing_index=0;
  bool reset=true;
  Completer<void>? _playbackCompleter;
  int? _currentPlayingIndex;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    addSongToChordMap(widget.chordData); // Ensure the song is added to the chordMap
  }

  void addChordToMap(String name, List<Chord> chords) {
    setState(() {
      chordMap[name] = SongChord(name: name, chords: chords);
    });
  }

  void _showChordVariantSelectionDialog(int startIndex, int chordIndex, String baseChord) {
    final variants = chordVariants[baseChord] ?? [];
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select a $baseChord variant'),
          children: variants.map((variant) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, baseChord + variant);
              },
              child: Text(baseChord + variant),
            );
          }).toList(),
        );
      },
    ).then((selectedChord) {
      if (selectedChord != null) {
        setState(() {
          chordMap[widget.name]?.chords[startIndex + chordIndex].name = selectedChord;
        });
      }
    });
  }

  void _showChordSelectionDialog(int startIndex, int chordIndex, bool isChi) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text((isChi) ? '選擇基本和弦' : 'Select a base chord'),
          children: allChords.map((chordOption) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, chordOption);
              },
              child: Text(chordOption),
            );
          }).toList(),
        );
      },
    ).then((selectedChord) {
      if (selectedChord != null) {
        _showChordVariantSelectionDialog(startIndex, chordIndex, selectedChord);
      }
    });
  }

  void _showPositionSelectionDialog(int startIndex, int chordIndex, bool isChi) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text((isChi) ? '選擇吉他把位' : 'Select a position'),
          children: ['1', '2', '3'].map((position) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, position);
              },
              child: Text(position),
            );
          }).toList(),
        );
      },
    ).then((selectedPosition) {
      if (selectedPosition != null) {
        setState(() {
          chordMap[widget.name]?.chords[startIndex + chordIndex].position = selectedPosition;
        });
      }
    });
  }

  void _showOverlay(BuildContext context, Offset offset, Chord chord) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        child: Material(
          color: Colors.transparent,
          child: Image.asset(
            'assets/images/chords/${chord.name}-${chord.position}.png',
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _playChordSound(Chord chord, int index, double vol) async {
    setState(() {
      _currentPlayingIndex = index;
    });

    await _audioPlayer.play('assets/images/sound/${chord.name}-${chord.position}.mp3', isLocal: true, volume: vol);

    // Wait for the duration of the sound to reset the index
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      _currentPlayingIndex = null;
    });
  }




Future<void> _playChordsSequentially(List<Chord> chords, int bpm, int frequency, double vol) async {
  setState(() {
    //reset=false;
    _playbackCompleter = Completer<void>();
  });

  final secondsPerBeat = 30 / bpm;
  const beatsPerChord = 4;
  //final durationPerChord = Duration(milliseconds: (beatsPerChord * secondsPerBeat * 1000).toInt());
  final durationPerSound = Duration(milliseconds: (secondsPerBeat * 1000).toInt());
  reset=false;

  for (int i = current_playing_index; i < chords.length; i++) {
    if (!isPlaying|| _playbackCompleter!.isCompleted)
    {
        current_playing_index=i;
        //_playbackCompleter!.complete();
        break;
    } 
    else if(reset)
    {
      current_playing_index=0;
      isPlaying=false;
      reset=false;
      break;
    }

    for (int j = 0; j < beatsPerChord; j++) {
      // 在每个拍子上播放 t.mp3
      _audioPlayerT.play('assets/images/sound/t.mp3', isLocal: true, volume: vol*0.5);
      
      if (j == 0) {
        // 在第一拍播放 Don.mp3
        _audioPlayerDon.play('assets/images/sound/Don.mp3', isLocal: true, volume: vol);
        // 播放和弦声音
        _playChordSound(chords[i], i, vol);
      }

      if (j == 2) {
        // 在第三拍播放 Da.mp3  
        _audioPlayerDa.play('assets/images/sound/Da.mp3', isLocal: true, volume: vol);
      }

      // 等待一个拍子的时间
      await Future.delayed(durationPerSound);
    }
    if(i==chords.length-1)
    {
      current_playing_index=0;
      isPlaying=false;
      break;
    }
  }

  setState(() {
    isPlaying = false;
    _playbackCompleter = null;
  });
}

  void _stopPlayback() {
    if (isPlaying && _playbackCompleter != null) {
      _playbackCompleter!.complete();
    }
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    _stopPlayback();
    _audioPlayer.stop();
    _audioPlayerDa.stop();
    _audioPlayerT.stop();
    _audioPlayerDon.stop();
    _bpmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songChord = chordMap[widget.name];
    final volumeProvider = Provider.of<VolumeProvider>(context);
    final languageprovider = Provider.of<Languageprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text((languageprovider.isChiFriendly) ? '和弦表' : 'Chord Chart'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/quiz-logo.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), // Adjust transparency
              BlendMode.dstATop,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: songChord != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (languageprovider.isChiFriendly) ? '${songChord.name}的和弦' : 'Chords for ${songChord.name}:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _bpmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'BPM',
                      hintText: (languageprovider.isChiFriendly) ? '輸入BPM' : 'Enter BPM',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                    onPressed: () {
                      int bpm = int.tryParse(_bpmController.text) ?? _bpm;
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                      _playChordsSequentially(songChord.chords, bpm, 1, volumeProvider.volume);
                    },
                    icon: Icon((!isPlaying )? Icons.play_arrow : Icons.pause),
                    label: Text((isPlaying ) ? ((languageprovider.isChiFriendly) ? '暫停' : 'Pause') : ((languageprovider.isChiFriendly) ? '播放' : 'Play')),
                  ),
                  SizedBox(width:10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        reset=true;
                        current_playing_index=0;
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text((languageprovider.isChiFriendly) ? '重置' : 'Reset'),
                  ),

                  ]
                 ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (songChord.chords.length / 4).ceil(),
                      itemBuilder: (BuildContext context, int index) {
                        int startIndex = index * 4;
                        int endIndex = (index + 1) * 4;
                        if (endIndex > songChord.chords.length) {
                          endIndex = songChord.chords.length;
                        }
                       List<Chord> chordsToShow = songChord.chords.sublist(startIndex, endIndex);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20), // Padding between rows
                          child: Wrap(
                            spacing: 20, // Spacing between chips
                            runSpacing: 20, // Spacing between rows
                            children: chordsToShow.asMap().entries.map((entry) {
                              int chordIndex = entry.key;
                              Chord chord = entry.value;
                              bool isPlaying = (startIndex + chordIndex == _currentPlayingIndex);
                              return MouseRegion(
                                onEnter: (event) => _showOverlay(context, event.position, chord),
                                onExit: (event) => _hideOverlay(),
                                child: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'other chords') {
                                      _showChordSelectionDialog(startIndex, chordIndex, languageprovider.isChiFriendly);
                                    } else if (value == 'position') {
                                      _showPositionSelectionDialog(startIndex, chordIndex, languageprovider.isChiFriendly);
                                    } else if (value == 'sound') {
                                      _playChordSound(chord, startIndex + chordIndex, volumeProvider.volume);
                                    }
                                  },
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: 'other chords',
                                      child: Text((languageprovider.isChiFriendly) ? '其他和弦' : 'Other Chords'),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'position',
                                      child: Text((languageprovider.isChiFriendly) ? '把位' : 'Position'),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'sound',
                                      child: Text((languageprovider.isChiFriendly) ? '播放聲音' : 'Sound'),
                                    ),
                                  ],
                                  child: GestureDetector(
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: isPlaying ? Colors.yellow : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              chord.name,
                                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Image.asset(
                                              'assets/images/chords/${chord.name}-${chord.position}.png',
                                              width: 50,
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  (languageprovider.isChiFriendly) ? '沒有適合的和弦...' : 'No chords available for this song.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
      ),
    );
  }
}

List<String> convertChordCsvToList(String chord_csv) {
  return chord_csv.split(',').map((chord) => chord.trim()).toList();
}

void addSongToChordMap(ChordData chordData) {
  if (!chordMap.containsKey(chordData.songName)) {
    List<String> chordList = convertChordCsvToList(chordData.chord_csv);
    List<Chord> chords = chordList.map((chordName) => Chord(name: chordName)).toList();
    chordMap[chordData.songName] = SongChord(name: chordData.songName, chords: chords);
  }
}
