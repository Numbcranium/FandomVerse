import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/merchandise_colors.dart';

class WithdrawPayoutResult {
  final bool success;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String? referenceId;

  WithdrawPayoutResult({
    required this.success,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    this.referenceId,
  });
}

class WithdrawPayoutSheet extends StatefulWidget {
  final double amount;
  final double maxBalance;
  final void Function(WithdrawPayoutResult result) onPayoutConfirmed;

  const WithdrawPayoutSheet({
    super.key,
    required this.amount,
    required this.maxBalance,
    required this.onPayoutConfirmed,
  });

  static Future<WithdrawPayoutResult?> show({
    required BuildContext context,
    required double amount,
    required double maxBalance,
  }) {
    return showModalBottomSheet<WithdrawPayoutResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: WithdrawPayoutSheet(
          amount: amount,
          maxBalance: maxBalance,
          onPayoutConfirmed: (result) => Navigator.pop(ctx, result),
        ),
      ),
    );
  }

  @override
  State<WithdrawPayoutSheet> createState() => _WithdrawPayoutSheetState();
}

class _WithdrawPayoutSheetState extends State<WithdrawPayoutSheet> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();

  static const List<String> _popularBanks = [
    'GTBank',
    'Access Bank',
    'Zenith Bank',
    'First Bank of Nigeria',
    'Kuda Microfinance Bank',
    'United Bank for Africa (UBA)',
    'OPay',
    'PalmPay',
    'Moniepoint',
  ];

  String _selectedBank = _popularBanks.first;
  bool _isProcessing = false;

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  void _fillSampleAccount() {
    setState(() {
      _accountNumberController.text = '0123456789';
      _accountNameController.text = 'Alex Morgan';
    });
  }

  Future<void> _submitPayout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final ref = 'WD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    widget.onPayoutConfirmed(
      WithdrawPayoutResult(
        success: true,
        bankName: _selectedBank,
        accountNumber: _accountNumberController.text.trim(),
        accountName: _accountNameController.text.trim(),
        referenceId: ref,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final subtextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54;
    final inputBg = isDark ? const Color(0xFF2A2A3C) : const Color(0xFFF3F4F6);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MerchColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_outlined,
                    color: MerchColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Withdrawal Payout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Enter destination bank account details',
                        style: TextStyle(
                          fontSize: 12,
                          color: subtextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: subtextColor),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: MerchColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: MerchColors.primary.withAlpha(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Withdraw Amount',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: subtextColor),
                  ),
                  Text(
                    '₦${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MerchColors.primary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Demo Autofill Helper
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _fillSampleAccount,
                icon: const Icon(Icons.auto_fix_high, size: 16, color: MerchColors.primary),
                label: const Text(
                  'Autofill Sample Bank Details',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: MerchColors.primary),
                ),
              ),
            ),

            // Bank Dropdown Selection
            Text(
              'Select Destination Bank',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedBank,
              dropdownColor: cardBg,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: inputBg,
                prefixIcon: Icon(Icons.account_balance, color: subtextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _popularBanks.map((bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank, style: TextStyle(color: textColor)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedBank = val);
              },
            ),

            const SizedBox(height: 14),

            // Account Number Input
            Text(
              'Account Number',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor, letterSpacing: 1.2),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                hintText: '10-digit Account Number',
                hintStyle: TextStyle(color: subtextColor.withAlpha(150)),
                filled: true,
                fillColor: inputBg,
                prefixIcon: Icon(Icons.pin_outlined, color: subtextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().length != 10) {
                  return 'Enter a valid 10-digit account number';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Account Name Input
            Text(
              'Account Holder Name',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _accountNameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Account Owner Name',
                hintStyle: TextStyle(color: subtextColor.withAlpha(150)),
                filled: true,
                fillColor: inputBg,
                prefixIcon: Icon(Icons.person_outline, color: subtextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Account holder name is required';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _submitPayout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MerchColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing Withdrawal...',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Withdraw ₦${widget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
