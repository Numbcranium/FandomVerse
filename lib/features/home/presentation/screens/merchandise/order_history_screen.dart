import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../models/merchandise/order_model.dart';
import '../../../../../models/merchandise/product_model.dart';
import '../../../../auth/data/repositories/merchandise/order_repository.dart';
import '../../../../auth/data/repositories/merchandise/product_repository.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() {
    return _OrderHistoryScreenState();
  }
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late final OrderRepository _orderRepository;
  late final ProductRepository _productRepository;

  List<OrderModel> orders = [];

  bool _isLoading = true;
  String? _errorMessage;

  String get userId {
    return FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  }

  @override
  void initState() {
    super.initState();

    _orderRepository = OrderRepositoryImpl(
      userId: userId,
    );

    _productRepository = ProductRepositoryImpl();

    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final loadedOrders = await _orderRepository.getOrders();

      if (!mounted) {
        return;
      }

      setState(() {
        orders = loadedOrders;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load order history.';
      });
    }
  }

  Future<void> _openOrder(OrderModel order) async {
    try {
      final List<ProductModel> products = [];

      for (final productId in order.productIds) {
        final product =
        await _productRepository.getProductById(productId);

        if (product != null) {
          products.add(product);
        }
      }

      if (!mounted) {
        return;
      }

      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return OrderDetailsScreen(
              order: order,
              products: products,
            );
          },
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load order products.'),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Color _statusColor(String status) {
    final value = status.toLowerCase();

    if (value.contains('completed') ||
        value.contains('delivered') ||
        value.contains('success')) {
      return MerchColors.success;
    }

    if (value.contains('pending') ||
        value.contains('processing')) {
      return MerchColors.primaryLight;
    }

    if (value.contains('cancel')) {
      return Colors.redAccent;
    }

    return MerchColors.textSecondary;
  }

  IconData _statusIcon(String status) {
    final value = status.toLowerCase();

    if (value.contains('completed') ||
        value.contains('delivered') ||
        value.contains('success')) {
      return Icons.check_circle_outline;
    }

    if (value.contains('pending') ||
        value.contains('processing')) {
      return Icons.access_time;
    }

    if (value.contains('cancel')) {
      return Icons.cancel_outlined;
    }

    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MerchColors.background,
      appBar: AppBar(
        backgroundColor: MerchColors.background,
        foregroundColor: MerchColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Order History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: MerchColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: MerchColors.primary,
      backgroundColor: MerchColors.surface,
      onRefresh: _loadOrders,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          final order = orders[index];

          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final statusColor = _statusColor(order.status);
    final statusIcon = _statusIcon(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: MerchColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MerchColors.primary.withOpacity(0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _openOrder(order),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: MerchColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: MerchColors.primaryLight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: MerchColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(order.createdAt),
                            style: const TextStyle(
                              color: MerchColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: MerchColors.textSecondary,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: MerchColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${order.productIds.length} product'
                          '${order.productIds.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: MerchColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Divider(
                  height: 1,
                  color: MerchColors.textSecondary.withOpacity(0.15),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: MerchColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₦${order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: MerchColors.primaryLight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    _buildStatusBadge(
                      status: order.status,
                      color: statusColor,
                      icon: statusIcon,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge({
    required String status,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: MerchColors.primary,
      backgroundColor: MerchColors.surface,
      onRefresh: _loadOrders,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height:
            MediaQuery.of(context).size.height * 0.65,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: MerchColors.textSecondary,
                      size: 64,
                    ),
                    SizedBox(height: 18),
                    Text(
                      'No orders yet',
                      style: TextStyle(
                        color: MerchColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your orders will appear here after you make a purchase.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MerchColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: MerchColors.textSecondary,
              size: 52,
            ),
            const SizedBox(height: 14),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MerchColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _loadOrders,
              style: ElevatedButton.styleFrom(
                backgroundColor: MerchColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}