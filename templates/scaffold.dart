import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';

class SangeetSeva extends StatefulWidget {
  final String title;
  final String? splashImage;

  const SangeetSeva({super.key, required this.title, this.splashImage});

  @override
  // ignore: library_private_types_in_public_api
  _SangeetSevaState createState() => _SangeetSevaState();
}

class _SangeetSevaState extends State<SangeetSeva> {
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
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      // leave some space at top
                      SizedBox(height: 10),

                      // your widgets here

                      // leave some space at bottom
                      SizedBox(height: 100),
                    ],
                  ),
                ),
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
