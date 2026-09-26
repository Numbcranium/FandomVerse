
import 'package:flutter/material.dart';

import '../../../../../app/theme/merchandise_colors.dart';
import '../../../../../mock/merchandise_mock.dart';
import '../../../../../models/merchandise/category_model.dart';
import 'shop_screen.dart';

class CategoryScreen extends StatelessWidget {
const CategoryScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: MerchColors.background,
appBar: AppBar(
backgroundColor: MerchColors.background,
foregroundColor: MerchColors.textPrimary,
elevation: 0,
title: const Text(
'Categories',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
body: GridView.builder(
padding: const EdgeInsets.all(16),
gridDelegate:
const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
crossAxisSpacing: 12,
mainAxisSpacing: 12,
childAspectRatio: 1.05,
),
itemCount: MerchandiseMock.categories.length,
itemBuilder: (context, index) {
final CategoryModel category =
MerchandiseMock.categories[index];

return InkWell(
borderRadius: BorderRadius.circular(18),
onTap: () {
Navigator.push(
context,
MaterialPageRoute<void>(
builder: (_) => ShopScreen(
initialCategory: category.name,
),
),
);
},
child: Container(
decoration: BoxDecoration(
color: MerchColors.surface,
borderRadius: BorderRadius.circular(18),
border: Border.all(
color: MerchColors.divider,
),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
width: 58,
height: 58,
decoration: BoxDecoration(
color: MerchColors.primary.withValues(
alpha: 0.12,
),
shape: BoxShape.circle,
),
child: Icon(
category.icon,
size: 30,
color: MerchColors.primaryLight,
),
),
const SizedBox(height: 12),
Padding(
padding: const EdgeInsets.symmetric(
horizontal: 8,
),
child: Text(
category.name,
textAlign: TextAlign.center,
style: const TextStyle(
color: MerchColors.textPrimary,
fontWeight: FontWeight.w600,
),
),
),
],
),
),
);
},
),
);
}
}
