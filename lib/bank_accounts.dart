import 'dart:async';
import 'package:flutter/material.dart';
import 'package:networth/common/const.dart';
import 'package:networth/common/datatypes.dart';
import 'package:networth/common/fb.dart';
import 'package:networth/common/utils.dart';
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
  final List<BankAccount> _bankAccounts = [];

  // controllers, listeners and focus nodes

  @override
  initState() {
    super.initState();

    refresh();
  }

  @override
  dispose() {
    // clear all lists and maps
    _bankAccounts.clear();

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
      _bankAccounts.clear();
      List bankAccountsRaw = await FB().getList(path: "BankAccounts");
      _bankAccounts.addAll(
        bankAccountsRaw
            .map((e) => Utils().convertRawToDatatype(e, BankAccount.fromJson))
            .toList(),
      );
    });

    // refresh all child widgets

    setState(() {
      _isLoading = false;
    });
  }

  Widget _createBankAccountCard(int index) {
    BankAccount account = _bankAccounts[index];

    return Widgets().createTopLevelCard(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ListTile(
          leading: Image.asset(Const().banks[account.bankName]?['logo'] ?? ""),
          title: Text("[${account.bankName}] ${account.nickname ?? ""}"),
          subtitle: Widgets().createResponsiveRow(context, [
            Text("Total balance: ${Const.currencySymbol} "),
            Text(
              ((account.savingsBalance ?? 0) + (account.fdBalance ?? 0))
                  .toString(),
            ),
          ]),
          trailing: Widgets().createContextMenu(["Edit", "Delete"], (
            value,
          ) async {
            if (value == "Delete") {
              Widgets().showConfirmDialog(
                context,
                "Delete bank account?",
                "Delete",
                () async {
                  List accountsRaw = await FB().getList(path: "BankAccounts");
                  List<BankAccount> accounts =
                      accountsRaw
                          .map(
                            (e) => Utils().convertRawToDatatype(
                              e,
                              BankAccount.fromJson,
                            ),
                          )
                          .toList();
                  int idx = accounts.indexWhere(
                    (a) =>
                        a.bankName == account.bankName &&
                        a.nickname == account.nickname,
                  );
                  if (idx != -1) {
                    accounts.removeAt(idx);
                    await FB().setValue(
                      path: "BankAccounts",
                      value: accounts.map((e) => e.toJson()).toList(),
                    );
                  }

                  setState(() {
                    _bankAccounts.removeAt(index);
                  });
                },
              );
            } else if (value == "Edit") {
              await _onAdd(oldAccount: account);
            }
          }),
        ),
      ),
    );
  }

  Future<void> _onAdd({BankAccount? oldAccount}) async {
    String? bankName;
    TextEditingController nicknameController = TextEditingController();
    TextEditingController savingsBalanceController = TextEditingController();
    TextEditingController fdBalanceController = TextEditingController();

    if (oldAccount != null) {
      bankName = oldAccount.bankName;
      nicknameController.text = oldAccount.nickname ?? "";
      savingsBalanceController.text =
          (oldAccount.savingsBalance ?? 0).toString();
      fdBalanceController.text = (oldAccount.fdBalance ?? 0).toString();
    }

    final formKey = GlobalKey<FormState>();

    await Widgets().showResponsiveDialog(
      context: context,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // dropdown for bank
            DropdownButtonFormField<String>(
              value: bankName,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a bank';
                }
                return null;
              },
              onChanged: (value) {
                bankName = value ?? "";
              },
            ),

            // savings balance
            SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Savings Balance'),
              keyboardType: TextInputType.number,
              controller: savingsBalanceController,
            ),

            // FD balance
            SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Fixed Deposit Balance',
              ),
              keyboardType: TextInputType.number,
              controller: fdBalanceController,
            ),

            // nickname
            SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
              ),
              controller: nicknameController,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop();
              BankAccount data = BankAccount(
                bankName: bankName!,
                nickname:
                    nicknameController.text.isEmpty
                        ? null
                        : nicknameController.text,
                savingsBalance:
                    savingsBalanceController.text.isEmpty
                        ? null
                        : int.tryParse(savingsBalanceController.text),
                fdBalance:
                    fdBalanceController.text.isEmpty
                        ? null
                        : int.tryParse(fdBalanceController.text),
              );

              if (oldAccount == null) {
                await FB().addToList(
                  listpath: "BankAccounts",
                  data: data.toJson(),
                );
              } else {
                List accountsRaw = await FB().getList(path: "BankAccounts");
                List<BankAccount> accounts =
                    accountsRaw
                        .map(
                          (e) => Utils().convertRawToDatatype(
                            e,
                            BankAccount.fromJson,
                          ),
                        )
                        .toList();
                int idx = accounts.indexWhere(
                  (a) =>
                      a.bankName == oldAccount.bankName &&
                      a.nickname == oldAccount.nickname,
                );
                if (idx != -1) {
                  accounts[idx] = data;
                  await FB().setValue(
                    path: "BankAccounts",
                    value: accounts.map((e) => e.toJson()).toList(),
                  );
                }
              }

              setState(() {
                if (oldAccount == null) {
                  _bankAccounts.add(data);
                } else {
                  int idx = _bankAccounts.indexWhere(
                    (a) =>
                        a.bankName == oldAccount.bankName &&
                        a.nickname == oldAccount.nickname,
                  );
                  if (idx != -1) {
                    _bankAccounts[idx] = data;
                  }
                }
              });
            }
          },
          child: Text(oldAccount == null ? "Add" : "Update"),
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
                onPressed: _onAdd,
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
                      ...List.generate(
                        _bankAccounts.length,
                        (index) => _createBankAccountCard(index),
                      ),

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
