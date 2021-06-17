import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "images/connection_lost.png",
      fit: BoxFit.cover,
    );
  }
}
