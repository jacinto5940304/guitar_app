import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:guitar_app/providers/LanguageProvider.dart';
import 'package:provider/provider.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define your color theme or use theme from context
    final languageprovider = Provider.of<Languageprovider>(context);
    final Color textColor = Theme.of(context).colorScheme.background;
    final Color backgroundColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: AppBar(
        title: Text((languageprovider.isChiFriendly) ? '我們是誰???' : 'What\'s more?'),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Container(
        color: backgroundColor,  // Set the background color
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageInfoCard(
                    imagePath: 'assets/images/jacinto.png',
                    info: (languageprovider.isChiFriendly) ? '風信子' : 'jacinto',
                    email: "111062240@email.nthu.edu.tw",
                    textColor: textColor,
                    linkedinUrl: 'https://www.instagram.com/hbg_jimmy34/',
                    isChi: languageprovider.isChiFriendly,
                  ),
                  ImageInfoCard(
                    imagePath: 'assets/images/jimmy.png',
                    info: (languageprovider.isChiFriendly) ? '吉米' : 'Jimmy',
                    email: "111062134@email.nthu.edu.tw",
                    textColor: textColor,
                    linkedinUrl: 'https://www.instagram.com/chm_1018/',
                    isChi: languageprovider.isChiFriendly,
                  ),
                  ImageInfoCard(
                    imagePath: 'assets/images/quo.png',
                    info: (languageprovider.isChiFriendly) ? '翰克' : 'Hank',
                    email: "111062213@email.nthu.edu.tw",
                    textColor: textColor,
                    linkedinUrl: 'https://www.instagram.com/hank.kuo/',
                    isChi: languageprovider.isChiFriendly,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageInfoCard extends StatelessWidget {
  final String imagePath;
  final String info;
  final String email;
  final Color textColor;
  final String linkedinUrl;
  final bool isChi;

  const ImageInfoCard({
    Key? key,
    required this.imagePath,
    required this.info,
    required this.email,
    required this.textColor,
    required this.linkedinUrl,
    required this.isChi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Text(
                info,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2,),
              Text(
                email,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.email, color: textColor),
                    onPressed: () => launch((isChi) ? '郵件到$email' :"mailto:$email"),
                  ),
                  IconButton(
                    icon: Icon(Icons.linked_camera, color: textColor),
                    onPressed: () => launch(linkedinUrl),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}