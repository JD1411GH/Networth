import 'dart:async';
import 'package:flutter/material.dart';
import 'package:networth/widgets/maintile.dart';
import 'package:synchronized/synchronized.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // scalars
  final Lock _lock = Lock();
  bool _isLoading = true;

  // lists

  // controllers, listeners and focus nodes

  @override
  initState() {
    super.initState();

    refresh();
  }

  @override
  dispose() {
    // clear all lists and maps

    // clear all controllers and focus nodes

    super.dispose();
  }

  Future<void> refresh() async {
    setState(() {
      _isLoading = true;
    });

    // access control

    await _lock.synchronized(() async {
      // your code here
    });

    // refresh all child widgets

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 200),
                  MainTile(title: "Networth", subtitle: "1,00,00"),
                ],
              ),
            ),
          ),
        ),

        // circular progress indicator
        if (_isLoading) const CircularProgressIndicator(),
      ],
    );
  }
}
