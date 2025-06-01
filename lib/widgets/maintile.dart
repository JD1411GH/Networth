import 'package:flutter/material.dart';
import 'package:networth/common/const.dart';
import 'package:networth/common/utils.dart';
import 'package:networth/widgets/widgets.dart';
import 'package:synchronized/synchronized.dart';

class MainTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const MainTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

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
    double maxWidth = Const.maxCardWidth;
    final double screenWidth = MediaQuery.of(context).size.width;
    maxWidth =
        (screenWidth > maxWidth && screenWidth < maxWidth * 2)
            ? screenWidth
            : maxWidth;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, minWidth: maxWidth),
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: widget.onTap,
            child: Card(
              color: Utils().getRandomDarkColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32), // Increased roundness
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // title
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: Center(
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.headlineLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),

                    // subtitle (no animation)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          widget.subtitle,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
