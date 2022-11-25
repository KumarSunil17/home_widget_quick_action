import 'dart:io';
import 'dart:math';

import 'package:custom_paint_demo/explore/explore_page.dart';
import 'package:custom_paint_demo/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:workmanager/workmanager.dart';

///
/// Created by Sunil Kumar
/// On 25-11-2022 02:33 PM
///
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setupQuickActions();
    setupHomeWidget();
  }

  void setupQuickActions() {
    QuickActions quickActions = const QuickActions();
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_explore') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ExplorePage()));
      } else if (shortcutType == 'action_profile') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      } else {}
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'action_explore', localizedTitle: 'Explore', icon: 'profile'),
      const ShortcutItem(
          type: 'action_profile', localizedTitle: 'Profile', icon: 'explore')
    ]);
  }

  void setupHomeWidget() {
    HomeWidget.setAppGroupId('homeWidgetExample');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  /// Called when Doing Background Work initiated from Widget
  void backgroundCallback(Uri? data) async {
    if (data == null) return null;
    if (data.host == 'onClickTitle') {
      final greetings = [
        'Hello',
        'Hallo',
        'Bonjour',
        'Hola',
        'Ciao',
      ];
      final selectedGreeting = greetings[Random().nextInt(greetings.length)];

      await HomeWidget.saveWidgetData<String>('title', selectedGreeting);
      await HomeWidget.updateWidget(
          name: 'HomeWidgetProvider', iOSName: 'HomeWidgetExample');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      showDialog(
          context: context,
          builder: (buildContext) => AlertDialog(
                title: const Text('App started from Home Screen Widget'),
                content: Text('Here is the URI: $uri'),
              ));
    }
  }

  // void _startBackgroundUpdate() {
  //   Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
  //       frequency: Duration(minutes: 15));
  // }
  //
  // void _stopBackgroundUpdate() {
  //   Workmanager().cancelByUniqueName('1');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await _sendData();
        await _updateWidget();
      }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Welcome to home",
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
          if (Platform.isAndroid)
            ElevatedButton(
              onPressed: _startBackgroundUpdate,
              child: Text('Update in background'),
            ),
          if (Platform.isAndroid)
            ElevatedButton(
              onPressed: _stopBackgroundUpdate,
              child: Text('Stop updating in background'),
            )
        ],
      ),
    );
  }

  void _startBackgroundUpdate() {
    Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: const Duration(minutes: 15));
  }

  void _stopBackgroundUpdate() {
    Workmanager().cancelByUniqueName('1');
  }

  Future<Future<List<bool?>?>?> _sendData() async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('title', "Date"),
        HomeWidget.saveWidgetData<String>(
            'message', DateFormat("dd.MM.yy hh:mm:s a").format(DateTime.now())),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
    return null;
  }

  Future<Future<bool?>?> _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'HomeWidgetProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }
}
