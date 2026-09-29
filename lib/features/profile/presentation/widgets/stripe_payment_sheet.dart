import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/merchandise_colors.dart';
import '../../../../core/services/stripe_service.dart';

class StripePaymentSheet extends StatefulWidget {
  final double amount;
  final String currencySymbol;
  final void Function(StripePaymentResult result) onPaymentComplete;

  const StripePaymentSheet({
    super.key,
    required this.amount,
    required this.onPaymentComplete,
    this.currencySymbol = '₦',
  });

  static Future<StripePaymentResult?> show({
    required BuildContext context,
    required double amount,
    String currencySymbol = '₦',
  }) {
    return showModalBottomSheet<StripePaymentResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: StripePaymentSheet(
          amount: amount,
          currencySymbol: currencySymbol,
          onPaymentComplete: (result) => Navigator.pop(ctx, result),
        ),
      ),
    );
  }

  @override
  State<StripePaymentSheet> createState() => _StripePaymentSheetState();
}

class _StripePaymentSheetState extends State<StripePaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _cardHolderController = TextEditingController();

  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _fillTestCard() {
    setState(() {
      _cardNumberController.text = '4242 4242 4242 4242';
      _expiryController.text = '12/28';
      _cvcController.text = '424';
      _cardHolderController.text = 'Fandom Fan';
      _errorMessage = null;
    });
  }

  IconData _getCardBrandIcon(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.startsWith('4')) return Icons.credit_card;
    if (clean.startsWith('5')) return Icons.payment;
    if (clean.startsWith('3')) return Icons.credit_card_sharp;
    return Icons.credit_card_outlined;
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final expParts = _expiryController.text.split('/');
    final expMonth = expParts.isNotEmpty ? expParts[0] : '';
    final expYear = expParts.length > 1 ? expParts[1] : '';

    final result = await StripeService.instance.processCardPayment(
      cardNumber: _cardNumberController.text,
      expMonth: expMonth,
      expYear: expYear,
      cvc: _cvcController.text,
      amount: widget.amount,
    );

    if (!mounted) return;

    if (!result.success) {
      setState(() {
        _isProcessing = false;
        _errorMessage = result.errorMessage ?? 'Payment failed. Please try again.';
      });
    } else {
      widget.onPaymentComplete(result);
    }
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

            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: MerchColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
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
                        'Stripe Card Payment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Secure 256-bit encrypted checkout',
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

            // Amount Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MerchColors.primary.withAlpha(25),
                    MerchColors.primary.withAlpha(10),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: MerchColors.primary.withAlpha(50)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top-Up Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: subtextColor,
                    ),
                  ),
                  Text(
                    '${widget.currencySymbol}${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MerchColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Fill Test Card Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _fillTestCard,
                icon: const Icon(Icons.flash_on, size: 16, color: MerchColors.primary),
                label: const Text(
                  'Fill Test Card (4242...)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: MerchColors.primary),
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Card Holder Name
            Text(
              'Cardholder Name',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _cardHolderController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'e.g. Alex Morgan',
                hintStyle: TextStyle(color: subtextColor.withAlpha(150)),
                filled: true,
                fillColor: inputBg,
                prefixIcon: Icon(Icons.person_outline, color: subtextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 14),

            // Card Number
            Text(
              'Card Number',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor, letterSpacing: 1.2),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                _CardNumberFormatter(),
              ],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: '4242 4242 4242 4242',
                hintStyle: TextStyle(color: subtextColor.withAlpha(150)),
                filled: true,
                fillColor: inputBg,
                prefixIcon: Icon(_getCardBrandIcon(_cardNumberController.text), color: MerchColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Card number required';
                if (!StripeService.instance.validateCardNumber(v)) return 'Invalid card digits';
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Row for Expiry & CVC
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiry Date',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _expiryController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          _CardExpiryFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: 'MM/YY',
                          hintStyle: TextStyle(color: subtextColor.withAlpha(150)),
                          filled: true,
                          fillColor: inputBg,
                          prefixIcon: Icon(Icons.calendar_today_outlined, color: subtextColor, size: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || !v.contains('/')) return 'MM/YY required';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CVC / CVV',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _cvcController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        style: TextStyle(color: textColor),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: InputDecoration(
                          hintText: '123',
                          hintStyle: TextStyle(color: subtextColor.withAlpha(150)),
                          filled: true,
                          fillColor: inputBg,
                          prefixIcon: Icon(Icons.shield_outlined, color: subtextColor, size: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 3) return 'Invalid CVC';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
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
                            'Processing with Stripe...',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payment, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Pay ${widget.currencySymbol}${widget.amount.toStringAsFixed(2)} with Stripe',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Stripe Footer
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user, size: 14, color: subtextColor),
                  const SizedBox(width: 6),
                  Text(
                    'Powered by Stripe • Test Mode Enabled',
                    style: TextStyle(fontSize: 11, color: subtextColor),
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

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
