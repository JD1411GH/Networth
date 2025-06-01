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
  String _animatedSubtitle = '';

  @override
  void initState() {
    super.initState();
    // Trigger the subtitle animation after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animatedSubtitle = widget.subtitle;
      });
    });
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

                    // subtitle
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_animatedSubtitle.length, (i) {
                          return _AnimatedChar(
                            char: _animatedSubtitle[i],
                            delay: Duration(milliseconds: 50 * i),
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: Colors.white),
                          );
                        }),
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

class _AnimatedChar extends StatefulWidget {
  final String char;
  final Duration delay;
  final TextStyle style;

  const _AnimatedChar({
    required this.char,
    required this.delay,
    required this.style,
  });

  @override
  State<_AnimatedChar> createState() => _AnimatedCharState();
}

class _AnimatedCharState extends State<_AnimatedChar> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: _animate ? 0 : 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final double angle = value * 1.2; // vertical flip
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateX(angle),
          child: Opacity(opacity: (1 - value).clamp(0.0, 1.0), child: child),
        );
      },
      child: Text(widget.char, style: widget.style),
    );
  }
}
