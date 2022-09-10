import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

String name = "Ma'mur Zaky Nurrokhman";
String email = "mamurzakynurrokhman@gmail.com";

class SocialMedia {
  String socialMediaName;
  String url;
  IconData icon;

  SocialMedia({
    required this.socialMediaName,
    required this.url,
    required this.icon,
  });
}

var socialMediaList = [
  SocialMedia(
      socialMediaName: "Ma'mur Zaky Nurrokhman",
      url: "https://www.facebook.com/mamur.nurrokhman/",
      icon: MdiIcons.facebook),
  SocialMedia(
      socialMediaName: "@zaky_nurrokhman",
      url: "https://www.instagram.com/zaky_nurrokhman/",
      icon: MdiIcons.instagram),
  SocialMedia(
      socialMediaName: "Ma'mur Zaky Nurrokhman",
      url: "https://www.linkedin.com/in/zakymzn/",
      icon: MdiIcons.linkedin),
  SocialMedia(
      socialMediaName: "zakymzn",
      url: "https://github.com/zakymzn",
      icon: MdiIcons.github),
];
