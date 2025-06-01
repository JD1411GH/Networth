import 'dart:async';
import 'package:flutter/material.dart';
import 'package:networth/accounts.dart';
import 'package:networth/common/datatypes.dart';
import 'package:networth/common/fb.dart';
import 'package:networth/common/utils.dart';
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
  int _networth = 10000;

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
      _networth = 0;
      List<BankAccount> bankAccounts = [];
      List bankAccountsRaw = await FB().getList(path: "BankAccounts");
      bankAccounts =
          bankAccountsRaw
              .map((e) => Utils().convertRawToDatatype(e, BankAccount.fromJson))
              .toList();
      for (var account in bankAccounts) {
        _networth += account.savingsBalance ?? 0;
        _networth += account.fdBalance ?? 0;
      }
    });

    // refresh all child widgets

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: Text(widget.title));
    return Stack(
      children: [
        Scaffold(
          appBar: appBar,
          body: RefreshIndicator(
            onRefresh: refresh,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableHeight = constraints.maxHeight;
                final appBarHeight =
                    appBar.preferredSize.height +
                    MediaQuery.of(context).padding.top;
                final contentHeight = 100.0; // Approximate height of MainTile
                final topPadding =
                    ((availableHeight - appBarHeight - contentHeight) / 2)
                        .clamp(0.0, double.infinity);
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: topPadding),
                          MainTile(
                            title: "Total Networth",
                            subtitle: "₹ $_networth",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Accounts(title: "Accounts"),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // circular progress indicator
        if (_isLoading) const CircularProgressIndicator(),
      ],
    );
  }
}
