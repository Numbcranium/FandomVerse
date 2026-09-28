import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../core/services/stripe_service.dart';
import '../widgets/stripe_payment_sheet.dart';
import '../widgets/withdraw_payout_sheet.dart';
import '../widgets/stripe_save_card_sheet.dart';

class SavedCard {
  final String id;
  final String last4;
  final String brand;
  final String expMonth;
  final String expYear;
  final String cardHolder;

  SavedCard({
    required this.id,
    required this.last4,
    required this.brand,
    required this.expMonth,
    required this.expYear,
    required this.cardHolder,
  });

  factory SavedCard.fromMap(Map<String, dynamic> map) {
    return SavedCard(
      id: map['id'] ?? '',
      last4: map['last4'] ?? '',
      brand: map['brand'] ?? '',
      expMonth: map['expMonth'] ?? '',
      expYear: map['expYear'] ?? '',
      cardHolder: map['cardHolder'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'last4': last4,
      'brand': brand,
      'expMonth': expMonth,
      'expYear': expYear,
      'cardHolder': cardHolder,
    };
  }
}

class WalletTransaction {
  final String id;
  final String title;
  final String type; // 'deposit', 'withdraw', 'purchase'
  final double amount;
  final DateTime date;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? 'purchase',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'amount': amount,
      'date': Timestamp.fromDate(date),
    };
  }
}

class WalletService {
  WalletService._();

  static final WalletService instance = WalletService._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Default wallet balance for a new user.
  static const double initialBalance = 100000.0;

  double _balance = 0.0;
  List<SavedCard> _savedCards = [];
  bool _initialized = false;

  double get balance => _balance;
  List<SavedCard> get savedCards => _savedCards;

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

      if (data?['savedCards'] is List) {
        _savedCards = (data!['savedCards'] as List)
            .map((e) => SavedCard.fromMap(Map<String, dynamic>.from(e)))
            .toList();
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

    if (data?['savedCards'] is List) {
      _savedCards = (data!['savedCards'] as List)
          .map((e) => SavedCard.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  /// Save a new card to Firebase.
  Future<bool> saveCard(SavedCard card) async {
    try {
      _savedCards.add(card);
      await _userDocument.set(
        {
          'savedCards': _savedCards.map((c) => c.toMap()).toList(),
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      _savedCards.removeWhere((c) => c.id == card.id);
      return false;
    }
  }

  /// Remove a saved card from Firebase.
  Future<bool> removeCard(String cardId) async {
    try {
      final cardToRemove = _savedCards.firstWhere((c) => c.id == cardId);
      _savedCards.removeWhere((c) => c.id == cardId);
      
      await _userDocument.set(
        {
          'savedCards': _savedCards.map((c) => c.toMap()).toList(),
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _logTransaction(String title, String type, double amount) async {
    try {
      final id = _firestore.collection('users').doc().id;
      final tx = WalletTransaction(
        id: id,
        title: title,
        type: type,
        amount: amount,
        date: DateTime.now(),
      );
      await _userDocument.collection('transactions').doc(id).set(tx.toMap());
    } catch (_) {}
  }

  Future<List<WalletTransaction>> getTransactions() async {
    try {
      final query = await _userDocument.collection('transactions').orderBy('date', descending: true).limit(20).get();
      return query.docs.map((doc) => WalletTransaction.fromMap(doc.data())).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add money to the Firebase wallet.
  Future<bool> saveCard(SavedCard card) async {
    try {
      _savedCards.add(card);
      await _userDocument.set(
        {
          'savedCards': _savedCards.map((c) => c.toMap()).toList(),
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      _savedCards.removeWhere((c) => c.id == card.id);
      return false;
    }
  }

  /// Remove a saved card from Firebase.
  Future<bool> removeCard(String cardId) async {
    try {
      final cardToRemove = _savedCards.firstWhere((c) => c.id == cardId);
      _savedCards.removeWhere((c) => c.id == cardId);
      
      await _userDocument.set(
        {
          'savedCards': _savedCards.map((c) => c.toMap()).toList(),
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      return false;
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
      
      await _logTransaction('Wallet Top-Up', 'deposit', amount);

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

      await _logTransaction('Withdrawal to Bank', 'withdraw', amount);

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

      await _logTransaction('Merchandise Payment', 'purchase', amount);

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
  List<WalletTransaction>? _transactions;

  @override
  void initState() {
    super.initState();
    _initializeWallet();
  }

  Future<void> _fetchTransactions() async {
    final txs = await _wallet.getTransactions();
    if (mounted) {
      setState(() {
        _transactions = txs;
      });
    }
  }

  Future<void> _initializeWallet() async {
    try {
      await StripeService.instance.initialize();
      await _wallet.init();
      await _fetchTransactions();
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
      title: 'Top Up Wallet Balance',
      buttonText: 'Continue to Payment',
    );

    if (!mounted || amount == null) {
      return;
    }

    // Prompt user to select payment method
    final paymentMethod = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose how you want to add ₦${amount.toStringAsFixed(0)} to your wallet',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: MerchColors.primary.withAlpha(80)),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MerchColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.credit_card, color: MerchColors.primary),
                ),
                title: Text(
                  'Stripe Card Payment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: const Text('Pay securely using Visa, Mastercard, or Amex'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pop(ctx, 'stripe'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bolt, color: Colors.amber),
                ),
                title: Text(
                  'Instant Demo Credit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: const Text('Directly credit balance without card entry'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pop(ctx, 'demo'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || paymentMethod == null) return;

    if (paymentMethod == 'stripe') {
      final stripeResult = await StripePaymentSheet.show(
        context: context,
        amount: amount,
      );

      if (!mounted || stripeResult == null || !stripeResult.success) {
        return;
      }

      final success = await _wallet.addMoney(amount);

      if (!mounted) return;

      if (success) {
        await _fetchTransactions();
      }

      setState(() {});

      if (success) {
        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Text('Payment Successful'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₦${amount.toStringAsFixed(0)} has been credited to your wallet via Stripe.',
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                if (stripeResult.transactionId != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      'Ref: ${stripeResult.transactionId}',
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    } else if (paymentMethod == 'demo') {
      final success = await _wallet.addMoney(amount);
      if (!mounted) return;
      
      if (success) {
        await _fetchTransactions();
      }
      
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? '₦${amount.toStringAsFixed(0)} added to your wallet.'
                : 'Unable to add money.',
          ),
          backgroundColor: success ? MerchColors.primary : Colors.red,
        ),
      );
    }
  }

  Future<void> _withdrawMoney() async {
    final amount = await _showAmountDialog(
      title: 'Withdraw Money',
      buttonText: 'Continue to Payout',
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

    final payoutResult = await WithdrawPayoutSheet.show(
      context: context,
      amount: amount,
      maxBalance: _wallet.balance,
    );

    if (!mounted || payoutResult == null || !payoutResult.success) {
      return;
    }

    final success = await _wallet.withdraw(amount);

    if (!mounted) {
      return;
    }

    if (success) {
      await _fetchTransactions();
    }

    setState(() {});

    if (success) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Withdrawal Processed'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₦${amount.toStringAsFixed(2)} has been sent to your bank account.',
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank: ${payoutResult.bankName}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      'Account: ${payoutResult.accountNumber} (${payoutResult.accountName})',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (payoutResult.referenceId != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Ref: ${payoutResult.referenceId}',
                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to complete withdrawal.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<void> _addCard() async {
    final card = await StripeSaveCardSheet.show(context: context);
    if (card != null && mounted) {
      final success = await _wallet.saveCard(card);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Card saved successfully!' : 'Failed to save card.'),
            backgroundColor: success ? MerchColors.primary : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeCard(SavedCard card) async {
    final success = await _wallet.removeCard(card.id);
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Card removed.' : 'Failed to remove card.'),
          backgroundColor: success ? MerchColors.primary : Colors.red,
        ),
      );
    }
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
            
            SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved Cards',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addCard,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Card', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            if (_wallet.savedCards.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    Icon(Icons.credit_card_off, color: Theme.of(context).textTheme.bodyMedium?.color, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'No saved cards',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Save a card for faster checkout',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ..._wallet.savedCards.map((card) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MerchColors.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          card.brand == 'Visa' ? Icons.credit_card : Icons.payment,
                          color: MerchColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${card.brand} •••• ${card.last4}',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Expires ${card.expMonth}/${card.expYear}',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeCard(card),
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Remove Card',
                      ),
                    ],
                  ),
                );
              }),
              
            SizedBox(height: 32),
            
            Text(
              'Transaction History',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            SizedBox(height: 12),
            
            if (_transactions == null)
              Center(child: CircularProgressIndicator(color: MerchColors.primary))
            else if (_transactions!.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    Icon(Icons.history, color: Theme.of(context).textTheme.bodyMedium?.color, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'No transactions yet',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  ],
                ),
              )
            else
              ..._transactions!.map((tx) {
                final isPositive = tx.type == 'deposit';
                final icon = tx.type == 'deposit' 
                    ? Icons.arrow_downward 
                    : (tx.type == 'withdraw' ? Icons.account_balance : Icons.shopping_bag);
                final color = tx.type == 'deposit' 
                    ? MerchColors.success 
                    : (tx.type == 'withdraw' ? Colors.orange : MerchColors.primary);
                    
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${tx.date.day}/${tx.date.month}/${tx.date.year} • ${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isPositive ? '+' : '-'}₦${tx.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isPositive ? MerchColors.success : Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
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