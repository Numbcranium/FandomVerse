import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/cart_item_model.dart';
import '../../../../../models/merchandise/order_model.dart';
import '../../../../../widgets/merchandise/price_widget.dart';
import '../../../../auth/data/repositories/merchandise/cart_repository.dart';
import '../../../../auth/data/repositories/merchandise/order_repository.dart';
import '../../../../profile/presentation/screens/wallet_screen.dart';
import '../../../../profile/presentation/widgets/stripe_payment_sheet.dart';
import '../../widgets/merchandise/price_widget.dart';
import 'order_details_screen.dart';

enum PaymentMethod { wallet, savedCard, newCard }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    this.items,
  });

  final List<CartItemModel>? items;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final OrderRepository _orderRepository;
  late final CartRepository _cartRepository;
  late final WalletService _walletService;

  bool _isPlacingOrder = false;
  bool _isLoadingWallet = true;
  PaymentMethod _paymentMethod = PaymentMethod.wallet;
  SavedCard? _selectedSavedCard;

  String get userId {
    return FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  }

  List<CartItemModel> get checkoutItems {
    return widget.items ?? [];
  }

  double get subtotal {
    return checkoutItems.fold<double>(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }

  double get total {
    return subtotal;
  }

  @override
  void initState() {
    super.initState();

    _orderRepository = OrderRepositoryImpl(
      userId: userId,
    );

    _cartRepository = CartRepositoryImpl(
      userId: userId,
    );

    _walletService = WalletService.instance;
    _initializeWallet();
  }

  Future<void> _initializeWallet() async {
    await _walletService.init();
    if (mounted) {
      setState(() {
        _isLoadingWallet = false;
        if (_walletService.savedCards.isNotEmpty) {
           _paymentMethod = PaymentMethod.savedCard;
           _selectedSavedCard = _walletService.savedCards.first;
        }
      });
    }
  }

  Future<void> _placeOrder() async {
    if (_isPlacingOrder || checkoutItems.isEmpty) {
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      if (_paymentMethod == PaymentMethod.wallet) {
        // Get the latest wallet balance from Firestore.
        await _walletService.refresh();

        // Check whether the wallet has enough money.
        if (_walletService.balance < total) {
          if (!mounted) return;

          final balance = _walletService.balance;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Insufficient wallet balance. '
                    'You need ₦${total.toStringAsFixed(2)}, '
                    'but your wallet has ₦${balance.toStringAsFixed(2)}.',
              ),
              action: SnackBarAction(
                label: 'Wallet',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const WalletScreen(),
                    ),
                  );
                },
              ),
            ),
          );
          setState(() => _isPlacingOrder = false);
          return;
        }

        // Deduct the money from the Firebase wallet.
        final paymentSuccessful = await _walletService.pay(total);

        if (!paymentSuccessful) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment failed. Please check your wallet and try again.'),
            ),
          );
          setState(() => _isPlacingOrder = false);
          return;
        }
      } else if (_paymentMethod == PaymentMethod.savedCard) {
        // Simulate processing saved card
        await Future.delayed(const Duration(seconds: 2));
      } else if (_paymentMethod == PaymentMethod.newCard) {
        final result = await StripePaymentSheet.show(
          context: context,
          amount: total,
        );
        if (result == null || !result.success) {
          if (mounted) {
            setState(() => _isPlacingOrder = false);
          }
          return;
        }
      }

      // Create the order after successful payment.
      final order = OrderModel(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        productIds: checkoutItems
            .map((item) => item.product.id)
            .toList(),
        totalAmount: total,
        status: 'Paid',
        createdAt: DateTime.now(),
      );

      // Save the order locally and to Firebase.
      await _orderRepository.createOrder(order);

      // Clear the cart locally and from Firebase.
      await _cartRepository.clearCart();

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (_) => OrderDetailsScreen(
            order: order,
            products: checkoutItems
                .map((item) => item.product)
                .toList(),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not place order: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentItems = checkoutItems;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: currentItems.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            ...currentItems.map(
                  (item) => _OrderItem(item: item),
            ),

            SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Subtotal',
                    value: subtotal,
                  ),
                  SizedBox(height: 12),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PriceWidget(
                        price: total,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Payment',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            _isLoadingWallet 
              ? Center(child: CircularProgressIndicator(color: MerchColors.primary))
              : Column(
                  children: [
                    if (_walletService.savedCards.isNotEmpty)
                      ..._walletService.savedCards.map((card) {
                        final isSelected = _paymentMethod == PaymentMethod.savedCard && _selectedSavedCard?.id == card.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _paymentMethod = PaymentMethod.savedCard;
                              _selectedSavedCard = card;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? MerchColors.primary : Theme.of(context).dividerColor,
                                width: isSelected ? 1.5 : 1.0,
                              ),
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
                                  child: Text(
                                    '${card.brand} •••• ${card.last4}',
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle, color: MerchColors.primary)
                                else
                                  Icon(Icons.circle_outlined, color: Theme.of(context).dividerColor),
                              ],
                            ),
                          ),
                        );
                      }),
                      
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _paymentMethod = PaymentMethod.wallet;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _paymentMethod == PaymentMethod.wallet ? MerchColors.primary : Theme.of(context).dividerColor,
                            width: _paymentMethod == PaymentMethod.wallet ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.account_balance_wallet_outlined, color: MerchColors.primaryLight),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Pay from Wallet',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (_paymentMethod == PaymentMethod.wallet)
                              Icon(Icons.check_circle, color: MerchColors.primary)
                            else
                              Icon(Icons.circle_outlined, color: Theme.of(context).dividerColor),
                          ],
                        ),
                      ),
                    ),
                    
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _paymentMethod = PaymentMethod.newCard;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _paymentMethod == PaymentMethod.newCard ? MerchColors.primary : Theme.of(context).dividerColor,
                            width: _paymentMethod == PaymentMethod.newCard ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add_card, color: MerchColors.primaryLight),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Pay with New Card',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (_paymentMethod == PaymentMethod.newCard)
                              Icon(Icons.check_circle, color: MerchColors.primary)
                            else
                              Icon(Icons.circle_outlined, color: Theme.of(context).dividerColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

            SizedBox(height: 12),

            if (_paymentMethod == PaymentMethod.wallet)
              Text(
                'Your wallet will be charged when you place the order.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 13,
                ),
              ),

            SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                _isPlacingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MerchColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isPlacingOrder
                    ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                )
                    : Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({
    required this.item,
  });

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          PriceWidget(
            price: item.subtotal,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        PriceWidget(
          price: value,
        ),
      ],
    );
  }
}