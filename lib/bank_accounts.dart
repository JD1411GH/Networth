import 'dart:async';
import 'package:flutter/material.dart';
import 'package:networth/common/const.dart';
import 'package:networth/common/datatypes.dart';
import 'package:networth/common/fb.dart';
import 'package:networth/widgets/widgets.dart';
import 'package:synchronized/synchronized.dart';

class BankAccounts extends StatefulWidget {
  final String title;
  final String? splashImage;

  const BankAccounts({super.key, required this.title, this.splashImage});

  @override
  // ignore: library_private_types_in_public_api
  _BankAccountsState createState() => _BankAccountsState();
}

class _BankAccountsState extends State<BankAccounts> {
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

  Future<void> onAdd() async {
    String bankName = "";
    String nickname = "";
    int savingsBalance = 0;
    int fdBalance = 0;

    await Widgets().showResponsiveDialog(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // dropdown for bank
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Bank',
                border: OutlineInputBorder(),
              ),
              items:
                  Const().banks.keys.map((String bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),

              onChanged: (value) {
                bankName = value ?? "";
              },
            ),

            // savings balance
            SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Savings Balance'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                savingsBalance = int.tryParse(value) ?? 0;
              },
            ),

            // FD balance
            SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Fixed Deposit Balance',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                fdBalance = int.tryParse(value) ?? 0;
              },
            ),

            // nickname
            SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
              ),
              onChanged: (value) {
                nickname = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();

            BankAccount data = BankAccount(
              bankName: bankName,
              nickname: nickname.isEmpty ? null : nickname,
              savingsBalance: savingsBalance,
              fdBalance: fdBalance,
            );
            // await FB().addToList(listpath: "BankAccounts", data: data);
            await FB().setValue(path: "somepath", value: "value");
          },
          child: Text("Add"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAdd,
                tooltip: 'Add Bank Account',
              ),
            ],
          ),
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
