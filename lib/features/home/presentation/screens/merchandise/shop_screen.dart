
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../core/widgets/cart_badge.dart';
import '../../../../../models/merchandise/product_model.dart';
import '../../../../auth/data/repositories/merchandise/product_repository.dart';
import '../../widgets/merchandise/product_card.dart';
import 'cart_screen.dart';
import 'category_screen.dart';
import 'order_history_screen.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';

class ShopScreen extends StatefulWidget {
const ShopScreen({
super.key,
this.initialCategory = 'All',
});

final String initialCategory;

@override
State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
late final ProductRepository _productRepository;

List<ProductModel> _products = [];
bool _isLoading = true;
String? _errorMessage;

late String selectedCategory;
String searchQuery = '';

@override
void initState() {
super.initState();

selectedCategory = widget.initialCategory;

_productRepository = ProductRepositoryImpl();

_loadProducts();
}

Future<void> _loadProducts() async {
try {
final products = await _productRepository.getProducts();

if (!mounted) {
return;
}

setState(() {
_products = products;
_isLoading = false;
_errorMessage = null;
});
} catch (_) {
if (!mounted) {
return;
}

setState(() {
_isLoading = false;
_errorMessage = 'Could not load merchandise.';
});
}
}

List<ProductModel> get filteredProducts {
return _products.where((product) {
final matchesCategory =
selectedCategory == 'All' ||
product.category.toLowerCase() ==
selectedCategory.toLowerCase();

final matchesSearch =
searchQuery.trim().isEmpty ||
product.name.toLowerCase().contains(
searchQuery.trim().toLowerCase(),
) ||
product.category.toLowerCase().contains(
searchQuery.trim().toLowerCase(),
);

return matchesCategory && matchesSearch;
}).toList();
}

@override
Widget build(BuildContext context) {
final products = filteredProducts;

return Scaffold(
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
appBar: AppBar(
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
elevation: 0,
title: Text(
'Shop',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
actions: [
IconButton(
tooltip: 'Wishlist',
onPressed: () {
Navigator.push(
context,
MaterialPageRoute<void>(
builder: (_) => const WishlistScreen(),
),
);
},
icon: Icon(
Icons.favorite_border,
),
),
CartBadge(
top: 0,
right: 4,
child: IconButton(
tooltip: 'Cart',
onPressed: () {
Navigator.push(
context,
MaterialPageRoute<void>(
builder: (_) => const CartScreen(),
),
);
},
icon: Icon(
Icons.shopping_cart_outlined,
),
),
),
],
),
floatingActionButton: CartBadge(
  top: -4,
  right: -4,
  child: FloatingActionButton(
    heroTag: 'shopCartFab',
    backgroundColor: MerchColors.primary,
    foregroundColor: Colors.white,
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const CartScreen(),
        ),
      );
    },
    child: Icon(Icons.shopping_cart_outlined),
  ),
),
body: _isLoading
? Center(
child: CircularProgressIndicator(
color: MerchColors.primary,
),
)
    : _errorMessage != null
? _buildErrorState()
    : Column(
children: [
_buildSearchBar(),
_buildCategoryChips(),
SizedBox(height: 8),
Expanded(
child: products.isEmpty
? _buildEmptyState()
    : RefreshIndicator(
color: MerchColors.primary,
onRefresh: _loadProducts,
child: GridView.builder(
padding: const EdgeInsets.fromLTRB(
16,
8,
16,
20,
),
gridDelegate:
const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
crossAxisSpacing: 12,
mainAxisSpacing: 12,
childAspectRatio: 0.72,
),
itemCount: products.length,
itemBuilder: (context, index) {
final product = products[index];

return ProductCard(
product: product,
onTap: () {
Navigator.push(
context,
MaterialPageRoute<void>(
builder: (_) =>
ProductDetailsScreen(
product: product,
),
),
);
},
);
},
),
),
),
],
),
bottomNavigationBar: SafeArea(
child: Padding(
padding: const EdgeInsets.fromLTRB(
16,
8,
16,
12,
),
child: Row(
children: [
Expanded(
child: OutlinedButton.icon(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute<void>(
builder: (_) => const CategoryScreen(),
),
);
},
icon: Icon(
Icons.grid_view_outlined,
),
label: Text('Categories'),
style: OutlinedButton.styleFrom(
foregroundColor: MerchColors.primaryLight,
side: const BorderSide(
color: MerchColors.primary,
),
padding: const EdgeInsets.symmetric(
vertical: 14,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
SizedBox(width: 10),
Expanded(
child: OutlinedButton.icon(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute<void>(
builder: (_) => const OrderHistoryScreen(),
),
);
},
icon: Icon(
Icons.receipt_long_outlined,
),
label: Text('Orders'),
style: OutlinedButton.styleFrom(
foregroundColor: MerchColors.primaryLight,
side: const BorderSide(
color: MerchColors.primary,
),
padding: const EdgeInsets.symmetric(
vertical: 14,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
),
),
],
),
),
),
);
}

Widget _buildSearchBar() {
return Padding(
padding: const EdgeInsets.fromLTRB(
16,
8,
16,
12,
),
child: TextField(
onChanged: (value) {
setState(() {
searchQuery = value;
});
},
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
),
decoration: InputDecoration(
hintText: 'Search anime merchandise...',
hintStyle: TextStyle(
color: Theme.of(context).textTheme.bodyMedium?.color,
),
prefixIcon: Icon(
Icons.search,
color: Theme.of(context).textTheme.bodyMedium?.color,
),
filled: true,
fillColor: Theme.of(context).cardColor,
contentPadding: const EdgeInsets.symmetric(
vertical: 14,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: MerchColors.primary,
),
),
),
),
);
}

Widget _buildCategoryChips() {
const categories = [
'All',
'Figures',
'Manga',
'Trading Cards',
'Posters & Art',
'Accessories',
'Collectibles',
'Limited Edition',
'Anime Gifts',
];

return SizedBox(
height: 42,
child: ListView.separated(
padding: const EdgeInsets.symmetric(
horizontal: 16,
),
scrollDirection: Axis.horizontal,
itemCount: categories.length,
separatorBuilder: (_, __) =>
SizedBox(width: 8),
itemBuilder: (context, index) {
final category = categories[index];
final selected =
selectedCategory == category;

return ChoiceChip(
label: Text(category),
selected: selected,
onSelected: (_) {
setState(() {
selectedCategory = category;
});
},
selectedColor: MerchColors.primary,
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
side: BorderSide(
color: selected
? MerchColors.primary
    : Theme.of(context).dividerColor,
),
labelStyle: TextStyle(
color: selected
? Colors.white
    : Theme.of(context).textTheme.bodyMedium?.color,
fontWeight: FontWeight.w600,
fontSize: 12,
),
);
},
),
);
}

Widget _buildEmptyState() {
return Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.search_off,
size: 54,
color: Theme.of(context).textTheme.bodyMedium?.color,
),
SizedBox(height: 14),
Text(
'No merchandise found',
style: TextStyle(
color: Theme.of(context).textTheme.bodyLarge?.color,
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 8),
Text(
'Try another search or category.',
textAlign: TextAlign.center,
style: TextStyle(
color: Theme.of(context).textTheme.bodyMedium?.color,
),
),
SizedBox(height: 18),
OutlinedButton(
onPressed: () {
setState(() {
selectedCategory = 'All';
searchQuery = '';
});
},
child: Text('Clear Filters'),
),
],
),
),
);
}

Widget _buildErrorState() {
return Center(
child: Padding(
padding: const EdgeInsets.all(24),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.error_outline,
size: 54,
color: Theme.of(context).textTheme.bodyMedium?.color,
),
SizedBox(height: 14),
Text(
_errorMessage!,
textAlign: TextAlign.center,
style: TextStyle(
color: Theme.of(context).textTheme.bodyMedium?.color,
),
),
SizedBox(height: 18),
ElevatedButton(
onPressed: () {
setState(() {
_isLoading = true;
_errorMessage = null;
});

_loadProducts();
},
child: Text('Try Again'),
),
],
),
),
);
}
}

