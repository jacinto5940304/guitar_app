// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class SongChord {
//   const SongChord({
//     required this.name,
//     required this.chords,
//   });

//   final String name;
//   final List<Chord> chords;
// }

// class Chord {
//   Chord({
//     required this.name,
//     this.position = '1',
//   });

//   String name;
//   String position;
// }

// class ChordChartPage extends StatefulWidget {
//   const ChordChartPage({
//     super.key,
//     required this.name,
//   });

//   final String name;

//   @override
//   _ChordChartPageState createState() => _ChordChartPageState();
// }

// final Map<String, SongChord> chordMap = {
//   "song1": SongChord(name: "song1", chords: [
//     Chord(name: 'C'), Chord(name: 'D'), Chord(name: 'Em'),
//     Chord(name: 'F'), Chord(name: 'G'), Chord(name: 'Am'),
//     Chord(name: 'Bm'), Chord(name: 'C'), Chord(name: 'D'),
//     Chord(name: 'Em'), Chord(name: 'F'), Chord(name: 'G'),
//     Chord(name: 'Am'), Chord(name: 'Bm'),
//   ]),
// };

// class _ChordChartPageState extends State<ChordChartPage> {
//   final List<String> allChords = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
//   final Map<String, List<String>> chordVariants = {
//     'A': ['', '7', 'm', 'm7', 'maj7'],
//     'B': ['', '7', 'm', 'm7', 'm7-5'],
//     'C': ['', '7', 'm', 'm7', 'm7-5', 'add9'],
//     'D': ['', '7', 'm', 'm7', 'sus2', 'sus4'],
//     'E': ['', '7', 'm', 'm7'],
//     'F': ['', '7', 'm', 'm7', 'maj7'],
//     'G': ['', '_B', '7', 'm', 'm7'],
//   };

//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final TextEditingController _bpmController = TextEditingController();
//   int _bpm = 90; // Default BPM

//   OverlayEntry? _overlayEntry;

//   void addChordToMap(String name, List<Chord> chords) {
//     setState(() {
//       chordMap[name] = SongChord(name: name, chords: chords);
//     });
//   }

//   void _showChordVariantSelectionDialog(int startIndex, int chordIndex, String baseChord) {
//     final variants = chordVariants[baseChord] ?? [];
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: Text('Select a $baseChord variant'),
//           children: variants.map((variant) {
//             return SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, baseChord + variant);
//               },
//               child: Text(baseChord + variant),
//             );
//           }).toList(),
//         );
//       },
//     ).then((selectedChord) {
//       if (selectedChord != null) {
//         setState(() {
//           chordMap[widget.name]?.chords[startIndex + chordIndex].name = selectedChord;
//         });
//       }
//     });
//   }

//   void _showChordSelectionDialog(int startIndex, int chordIndex) {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Select a base chord'),
//           children: allChords.map((chordOption) {
//             return SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, chordOption);
//               },
//               child: Text(chordOption),
//             );
//           }).toList(),
//         );
//       },
//     ).then((selectedChord) {
//       if (selectedChord != null) {
//         _showChordVariantSelectionDialog(startIndex, chordIndex, selectedChord);
//       }
//     });
//   }

//   void _showPositionSelectionDialog(int startIndex, int chordIndex) {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Select a position'),
//           children: ['1', '2', '3'].map((position) {
//             return SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, position);
//               },
//               child: Text(position),
//             );
//           }).toList(),
//         );
//       },
//     ).then((selectedPosition) {
//       if (selectedPosition != null) {
//         setState(() {
//           chordMap[widget.name]?.chords[startIndex + chordIndex].position = selectedPosition;
//         });
//       }
//     });
//   }

//   void _showOverlay(BuildContext context, Offset offset, Chord chord) {
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy,
//         child: Material(
//           color: Colors.transparent,
//           child: Image.asset(
//             'assets/images/chords/${chord.name}-${chord.position}.png',
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context)!.insert(_overlayEntry!);
//   }

//   void _hideOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   Future<void> _playChordSound(Chord chord) async {
//     await _audioPlayer.play('assets/images/sound/${chord.name}-${chord.position}.mp3', isLocal: true);
//   }

//   Future<void> _playChordsSequentially(List<Chord> chords, int bpm) async {
//     final secondsPerBeat = 60 / bpm;
//     const beatsPerChord = 4;
//     final durationPerChord = Duration(milliseconds: (beatsPerChord * secondsPerBeat * 1000).toInt());

//     for (final chord in chords) {
//       await _playChordSound(chord);
//       await Future.delayed(durationPerChord);
//     }
//   }

//   @override
//   void dispose() {
//     _bpmController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final songChord = chordMap[widget.name];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chord Chart'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/quiz-logo.png'),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.3), // 调整透明度
//               BlendMode.dstATop,
//             ),
//           ),
//         ),
//         padding: const EdgeInsets.all(16.0),
//         child: songChord != null
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Chords for ${songChord.name}:',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   SizedBox(height: 10),
//                   TextField(
//                     controller: _bpmController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'BPM',
//                       hintText: 'Enter BPM',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       int bpm = int.tryParse(_bpmController.text) ?? _bpm;
//                       _playChordsSequentially(songChord.chords, bpm);
//                     },
//                     child: Text('Play Chords Sequentially'),
//                   ),
//                   SizedBox(height: 10),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: (songChord.chords.length / 8).ceil(),
//                       itemBuilder: (BuildContext context, int index) {
//                         int startIndex = index * 8;
//                         int endIndex = (index + 1) * 8;
//                         if (endIndex > songChord.chords.length) {
//                           endIndex = songChord.chords.length;
//                         }
//                         List<Chord> chordsToShow = songChord.chords.sublist(startIndex, endIndex);
//                         return Padding(
//                           padding: EdgeInsets.only(bottom: 20), // 在行之间添加底部填充
//                           child: Wrap(
//                             spacing: 20, // 芯片之间的间距
//                             runSpacing: 20, // 行之间的间距
//                             children: chordsToShow.asMap().entries.map((entry) {
//                               int chordIndex = entry.key;
//                               Chord chord = entry.value;
//                               return MouseRegion(
//                                 onEnter: (event) => _showOverlay(context, event.position, chord),
//                                 onExit: (event) => _hideOverlay(),
//                                 child: PopupMenuButton<String>(
//                                   onSelected: (value) {
//                                     if (value == 'other chords') {
//                                       _showChordSelectionDialog(startIndex, chordIndex);
//                                     } else if (value == 'position') {
//                                       _showPositionSelectionDialog(startIndex, chordIndex);
//                                     } else if (value == 'sound') {
//                                       _playChordSound(chord);
//                                     }
//                                   },
//                                   color: Theme.of(context).colorScheme.secondaryContainer,
//                                   itemBuilder: (BuildContext context) => [
//                                     PopupMenuItem<String>(
//                                       value: 'other chords',
//                                       child: Text('Other Chords'),
//                                     ),
//                                     PopupMenuItem<String>(
//                                       value: 'position',
//                                       child: Text('Position'),
//                                     ),
//                                     PopupMenuItem<String>(
//                                       value: 'sound',
//                                       child: Text('Sound'),
//                                     ),
//                                   ],
//                                   child: GestureDetector(
//                                     child: Card(
//                                       elevation: 4,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Text(
//                                               chord.name,
//                                               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                                             ),
//                                             SizedBox(height: 5),
//                                             Image.asset(
//                                               'assets/images/chords/${chord.name}-${chord.position}.png',
//                                               width: 50,
//                                               height: 50,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               )
//             : Center(
//                 child: Text(
//                   'No chords available for this song.',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//       ),
//     );
//   }
// }
