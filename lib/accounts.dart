import 'dart:async';
import 'package:flutter/material.dart';
import 'package:networth/bank_accounts.dart';
import 'package:networth/common/datatypes.dart';
import 'package:networth/common/fb.dart';
import 'package:networth/common/utils.dart';
import 'package:networth/mf_accounts.dart';
import 'package:networth/widgets/maintile.dart';
import 'package:synchronized/synchronized.dart';

class Accounts extends StatefulWidget {
  final String title;
  final String? splashImage;

  const Accounts({super.key, required this.title, this.splashImage});

  @override
  // ignore: library_private_types_in_public_api
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  // scalars
  final Lock _lock = Lock();
  bool _isLoading = true;
  int _bankAccountsSum = 0;

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
      _bankAccountsSum = 0;
      List<BankAccount> bankAccounts = [];
      List bankAccountsRaw = await FB().getList(path: "BankAccounts");
      bankAccounts =
          bankAccountsRaw
              .map((e) => Utils().convertRawToDatatype(e, BankAccount.fromJson))
              .toList();
      for (var account in bankAccounts) {
        _bankAccountsSum += account.savingsBalance ?? 0;
        _bankAccountsSum += account.fdBalance ?? 0;
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
                final contentHeight =
                    300.0; // Approximate height of your content (adjust as needed)
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
                          SizedBox(
                            height: topPadding,
                          ), // to vertically align all widgets
                          // Bank accounts
                          MainTile(
                            title: "Bank Accounts",
                            subtitle: "₹ $_bankAccountsSum",
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const BankAccounts(
                                          title: "Bank Accounts",
                                        ),
                                  ),
                                ),
                          ),

                          MainTile(
                            title: "Mutual Funds",
                            subtitle: "₹ 0",
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const MFAccounts(
                                          title: "Mutual Funds",
                                        ),
                                  ),
                                ),
                          ),

                          // leave some space at bottom
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
