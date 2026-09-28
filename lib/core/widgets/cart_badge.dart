import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    super.key,
    required this.child,
    this.right = 0,
    this.top = 0,
  });

  final Widget child;
  final double right;
  final double top;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return child;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .snapshots(),
      builder: (context, snapshot) {
        int count = 0;
        if (snapshot.hasData) {
          count = snapshot.data!.docs.fold<int>(
            0,
            (sum, doc) => sum + ((doc.data() as Map<String, dynamic>)['quantity'] as int? ?? 1),
          );
        }

        if (count == 0) return child;

        return Stack(
          alignment: Alignment.center,
          children: [
            child,
            Positioned(
              right: right,
              top: top,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 1.5),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
