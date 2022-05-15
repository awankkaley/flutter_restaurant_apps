
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/platform_widget.dart';

class SettingsScreen extends StatelessWidget{
  static const routeName = "/settings_screen";

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Text("Settings"),
    );
  }

  Widget _buildIos(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: Text("Settings"),
    );
  }

}