import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar
/// On 25-11-2022 02:33 PM
///
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome to Profile",
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
