import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar
/// On 25-11-2022 02:33 PM
///
class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome to Explore",
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
