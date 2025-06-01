import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class MainTile extends StatefulWidget {
  final String title;
  final String subtitle;

  const MainTile({super.key, required this.title, required this.subtitle});

  @override
  State<MainTile> createState() => MainTileState();
}

// hint: put the global key as a member of the calling class
// instantiate the class with a global key
// final GlobalKey<_SummaryState> _summaryKey = GlobalKey<_SummaryState>();

class MainTileState extends State<MainTile> {
  final Lock _lock = Lock();

  @override
  void initState() {
    super.initState();

    refresh();
  }

  @override
  dispose() {
    // clear all lists

    // dispose all controllers

    super.dispose();
  }

  Future<void> refresh() async {
    // perform async work here

    await _lock.synchronized(() async {
      // perform sync work here
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
