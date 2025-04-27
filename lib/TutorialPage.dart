// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:guitar_app/providers/LanguageProvider.dart';


class Tutorialpage extends StatelessWidget {


  PageController _pageController = PageController(initialPage: 0);

  Tutorialpage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageprovider = Provider.of<Languageprovider>(context);

    return Scaffold(

      body:
        PageView(
          controller: _pageController,
          onPageChanged: (newIndex)
          {
            //
          },
          children:
         [
          page_1(pageController: _pageController, isChi: languageprovider.isChiFriendly),
          page_2(pageController: _pageController, isChi: languageprovider.isChiFriendly),
          page_3(pageController: _pageController, isChi: languageprovider.isChiFriendly),
         ],)
    );
  }
}

class page_1 extends StatelessWidget {
  final PageController pageController;
  final bool isChi;

  page_1({required this.pageController, required this.isChi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text((!isChi) ? 
                'Enter the song that you want to transfer to chords, and choose the genre you want by clicking the scroll bar on the right.' :
                '輸入你想轉換成和弦的歌曲，並通過點擊右側的滾動條選擇你想要的音樂類型。',
                textAlign: TextAlign.center,
                style:TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text((isChi) ? '上一頁' : 'Previous'),
                ),
                SizedBox(width:20),
                ElevatedButton(
                  onPressed: () {
                    pageController.animateToPage(
                      1, 
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: Text((isChi) ? '下一頁' : 'Next'),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
class page_2 extends StatelessWidget {

  final PageController pageController;
  final bool isChi;

  page_2({required this.pageController, required this.isChi});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text((!isChi) ?
                'Drag the song you want to the bottom to generate chord sheet, and make it your favorite song by pressing \'heart\' button on the left of the song\'s name.' : 
                '將你想要的歌曲拖曳到底部生成和弦譜，並通過按下歌曲名稱左側的「心形」按鈕將其設為你最喜愛的歌曲。',
                textAlign: TextAlign.center,
                style:TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    pageController.animateToPage(
                      0, 
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: Text((isChi) ? '上一頁' : 'Previous'),
                ),
                SizedBox(width:20),
                ElevatedButton(
                  onPressed: () {
                    pageController.animateToPage(
                      2, 
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                 child: Text((isChi) ? '下一頁' : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class page_3 extends StatelessWidget {

  final PageController pageController;
  final bool isChi;

  page_3({required this.pageController, required this.isChi});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text((!isChi) ?
                'Your favorite songs and chord sheets will be listed in the \"Favorite Song\" category. Delete the chord sheet you don\'t want by swiping it left or right.' :
                '你最喜愛的歌曲和和弦譜將列在「最愛歌曲」分類中。通過向左或向右滑動來刪除你不想要的和弦譜。',
                textAlign: TextAlign.center,
                style:TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ElevatedButton(
                  onPressed: () {
                    pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: Text((isChi) ? '上一頁' : 'Previous'),
                ),
                SizedBox(width:20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text((isChi) ? '完成' : 'Done'),
                ),
                
               
              ],
            ),
            /*ElevatedButton(
              onPressed: () {
                pageController.animateToPage(
                  2,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              child: Text('Next'),
            ),*/
          ],
        ),
      ),
    );
  }
}