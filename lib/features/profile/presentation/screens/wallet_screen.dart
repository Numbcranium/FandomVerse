import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';

class WalletService {
  WalletService._();

  static final WalletService instance = WalletService._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Default wallet balance for a new user.
  static const double initialBalance = 100000.0;

  double _balance = 0.0;
  bool _initialized = false;

  double get balance => _balance;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _userDocument {
    return _firestore.collection('users').doc(_userId);
  }

  /// Load the wallet balance from Firebase.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    final snapshot = await _userDocument.get();

    if (!snapshot.exists) {
      _balance = initialBalance;

      await _userDocument.set(
        {
          'walletBalance': _balance,
        },
        SetOptions(merge: true),
      );
    } else {
      final data = snapshot.data();

      final savedBalance = data?['walletBalance'];

      if (savedBalance is num) {
        _balance = savedBalance.toDouble();
      } else {
        _balance = initialBalance;

        await _userDocument.set(
          {
            'walletBalance': _balance,
          },
          SetOptions(merge: true),
        );
      }
    }

    _initialized = true;
  }

  /// Refresh the wallet balance from Firebase.
  Future<void> refresh() async {
    final snapshot = await _userDocument.get();

    if (!snapshot.exists) {
      _balance = initialBalance;

      await _userDocument.set(
        {
          'walletBalance': _balance,
        },
        SetOptions(merge: true),
      );

      return;
    }

    final data = snapshot.data();
    final savedBalance = data?['walletBalance'];

    if (savedBalance is num) {
      _balance = savedBalance.toDouble();
    } else {
      _balance = initialBalance;

      await _userDocument.set(
        {
          'walletBalance': _balance,
        },
        SetOptions(merge: true),
      );
    }
  }

  /// Add money to the Firebase wallet.
  Future<bool> addMoney(double amount) async {
    if (amount <= 0) {
      return false;
    }

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(_userDocument);

        final data = snapshot.data();

        double currentBalance = 0.0;

        if (data?['walletBalance'] is num) {
          currentBalance =
              (data!['walletBalance'] as num).toDouble();
        }

        final newBalance = currentBalance + amount;

        transaction.set(
          _userDocument,
          {
            'walletBalance': newBalance,
          },
          SetOptions(merge: true),
        );

        _balance = newBalance;
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Withdraw money from the Firebase wallet.
  Future<bool> withdraw(double amount) async {
    if (amount <= 0) {
      return false;
    }

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(_userDocument);

        final data = snapshot.data();

        double currentBalance = 0.0;

        if (data?['walletBalance'] is num) {
          currentBalance =
              (data!['walletBalance'] as num).toDouble();
        }

        if (amount > currentBalance) {
          throw Exception('Insufficient balance.');
        }

        final newBalance = currentBalance - amount;

        transaction.update(
          _userDocument,
          {
            'walletBalance': newBalance,
          },
        );

        _balance = newBalance;
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Pay for a merchandise order.
  ///
  /// The payment is performed inside a Firebase transaction
  /// so the balance cannot go below zero.
  Future<bool> pay(double amount) async {
    if (amount <= 0) {
      return false;
    }

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(_userDocument);

        final data = snapshot.data();

        double currentBalance = 0.0;

        if (data?['walletBalance'] is num) {
          currentBalance =
              (data!['walletBalance'] as num).toDouble();
        }

        if (currentBalance < amount) {
          throw Exception('Insufficient wallet balance.');
        }

        final newBalance = currentBalance - amount;

        transaction.update(
          _userDocument,
          {
            'walletBalance': newBalance,
          },
        );

        _balance = newBalance;
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check whether the wallet can afford an amount.
  Future<bool> canAfford(double amount) async {
    if (amount <= 0) {
      return false;
    }

    await refresh();

    return _balance >= amount;
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletService _wallet = WalletService.instance;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeWallet();
  }

  Future<void> _initializeWallet() async {
    try {
      await _wallet.init();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please log in to access your wallet.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  String _formatMoney(double amount) {
    return '₦${amount.toStringAsFixed(0)}';
  }

  Future<double?> _showAmountDialog({
    required String title,
    required String buttonText,
  }) async {
    String enteredAmount = '';

    final result = await showDialog<double>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: MerchColors.surface,
          title: Text(
            title,
            style: const TextStyle(
              color: MerchColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            onChanged: (value) {
              enteredAmount = value;
            },
            style: const TextStyle(
              color: MerchColors.textPrimary,
            ),
            decoration: InputDecoration(
              prefixText: '₦ ',
              prefixStyle: const TextStyle(
                color: MerchColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              hintText: 'Enter amount',
              hintStyle: const TextStyle(
                color: MerchColors.textSecondary,
              ),
              filled: true,
              fillColor: MerchColors.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: MerchColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: MerchColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final text = enteredAmount.trim().replaceAll(',', '');
                final value = double.tryParse(text);

                if (value == null || value <= 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid amount.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.of(dialogContext).pop(value);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MerchColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );

    return result;
  }
  Future<void> _addMoney() async {
    final amount = await _showAmountDialog(
      title: 'Add Money',
      buttonText: 'Add Money',
    );

    if (!mounted || amount == null) {
      return;
    }

    final success = await _wallet.addMoney(amount);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '${_formatMoney(amount)} added to your wallet.'
              : 'Unable to add money.',
        ),
        backgroundColor:
        success ? MerchColors.primary : Colors.red,
      ),
    );
  }

  Future<void> _withdrawMoney() async {
    final amount = await _showAmountDialog(
      title: 'Withdraw Money',
      buttonText: 'Withdraw',
    );

    if (!mounted || amount == null) {
      return;
    }

    if (amount > _wallet.balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You cannot withdraw more than your wallet balance.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await _wallet.withdraw(amount);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '${_formatMoney(amount)} withdrawn successfully.'
              : 'Unable to withdraw money.',
        ),
        backgroundColor:
        success ? MerchColors.primary : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Wallet',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: MerchColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Wallet',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WALLET BALANCE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MerchColors.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Wallet Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    _formatMoney(_wallet.balance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: _WalletActionButton(
                    icon: Icons.add,
                    label: 'Add Money',
                    onTap: _addMoney,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _WalletActionButton(
                    icon: Icons.arrow_upward,
                    label: 'Withdraw',
                    onTap: _withdrawMoney,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            Text(
              'Wallet',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: MerchColors.primary,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your wallet balance is used when you pay for merchandise orders.',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // CURRENT BALANCE INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: MerchColors.primary,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Available balance: ${_formatMoney(_wallet.balance)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Future<void> Function() onTap;

  const _WalletActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () async {
          await onTap();
        },
        icon: Icon(
          icon,
          size: 20,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).cardColor,
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          elevation: 0,
          side: BorderSide(color: Theme.of(context).dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}