import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../app/theme/merchandise_colors.dart';

class WalletService {
  WalletService._();

  static final WalletService instance = WalletService._();

  static const String _walletKey = 'merchandise_wallet_balance';

  // First-time wallet balance.
  static const double initialBalance = 100000.0;

  double _balance = initialBalance;
  bool _initialized = false;

  double get balance => _balance;

  Future<void> init() async {
    if (_initialized) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final savedBalance = prefs.getDouble(_walletKey);

    if (savedBalance == null) {
      // First time opening the wallet.
      _balance = initialBalance;

      await prefs.setDouble(
        _walletKey,
        _balance,
      );
    } else {
      // Use the previously saved balance.
      _balance = savedBalance;
    }

    _initialized = true;
  }

  Future<void> _saveBalance() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(
      _walletKey,
      _balance,
    );
  }

  Future<bool> addMoney(double amount) async {
    await init();

    if (amount <= 0) {
      return false;
    }

    _balance += amount;

    await _saveBalance();

    return true;
  }

  Future<bool> withdraw(double amount) async {
    await init();

    if (amount <= 0) {
      return false;
    }

    if (amount > _balance) {
      return false;
    }

    _balance -= amount;

    await _saveBalance();

    return true;
  }

  /// Used when the customer orders a product.
  ///
  /// Returns true if payment was successful.
  /// Returns false if the wallet does not have enough money.
  Future<bool> pay(double amount) async {
    await init();

    if (amount <= 0) {
      return false;
    }

    if (_balance < amount) {
      return false;
    }

    _balance -= amount;

    await _saveBalance();

    return true;
  }

  Future<bool> canAfford(double amount) async {
    await init();

    return amount > 0 && _balance >= amount;
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
    await _wallet.init();

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
    final controller = TextEditingController();

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
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
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
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
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
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: MerchColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim().replaceAll(',', '');

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

    controller.dispose();

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
        backgroundColor: success ? MerchColors.primary : Colors.red,
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
        backgroundColor: success ? MerchColors.primary : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: MerchColors.background,
        appBar: AppBar(
          backgroundColor: MerchColors.background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Wallet',
            style: TextStyle(
              color: MerchColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconTheme: const IconThemeData(
            color: MerchColors.textPrimary,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: MerchColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MerchColors.background,
      appBar: AppBar(
        backgroundColor: MerchColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Wallet',
          style: TextStyle(
            color: MerchColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: MerchColors.textPrimary,
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
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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

            const SizedBox(height: 24),

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
                const SizedBox(width: 12),
                Expanded(
                  child: _WalletActionButton(
                    icon: Icons.arrow_upward,
                    label: 'Withdraw',
                    onTap: _withdrawMoney,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Wallet',
              style: TextStyle(
                color: MerchColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: MerchColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
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
                        color: MerchColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CURRENT BALANCE INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: MerchColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: MerchColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Available balance: ${_formatMoney(_wallet.balance)}',
                      style: const TextStyle(
                        color: MerchColors.textPrimary,
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
          backgroundColor: MerchColors.surface,
          foregroundColor: MerchColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}