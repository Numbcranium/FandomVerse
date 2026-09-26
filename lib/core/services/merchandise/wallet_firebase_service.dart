import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletFirebaseService {
  WalletFirebaseService._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    return user.uid;
  }

  static DocumentReference<Map<String, dynamic>> get _userDocument {
    return _firestore.collection('users').doc(_uid);
  }

  /// Get the current wallet balance.
  static Future<double> getBalance() async {
    final snapshot = await _userDocument.get();

    if (!snapshot.exists) {
      await _userDocument.set(
        {
          'walletBalance': 0.0,
        },
        SetOptions(merge: true),
      );

      return 0.0;
    }

    final data = snapshot.data();

    if (data == null || data['walletBalance'] == null) {
      await _userDocument.set(
        {
          'walletBalance': 0.0,
        },
        SetOptions(merge: true),
      );

      return 0.0;
    }

    final balance = data['walletBalance'];

    if (balance is num) {
      return balance.toDouble();
    }

    return 0.0;
  }

  /// Add money to the wallet.
  static Future<double> addMoney(double amount) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than ₦0.');
    }

    final userDocument = _userDocument;

    return _firestore.runTransaction<double>((transaction) async {
      final snapshot = await transaction.get(userDocument);

      final data = snapshot.data();

      double currentBalance = 0.0;

      if (data != null && data['walletBalance'] is num) {
        currentBalance =
            (data['walletBalance'] as num).toDouble();
      }

      final newBalance = currentBalance + amount;

      transaction.set(
        userDocument,
        {
          'walletBalance': newBalance,
        },
        SetOptions(merge: true),
      );

      return newBalance;
    });
  }

  /// Withdraw money from the wallet.
  static Future<double> withdraw(double amount) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than ₦0.');
    }

    final userDocument = _userDocument;

    return _firestore.runTransaction<double>((transaction) async {
      final snapshot = await transaction.get(userDocument);

      final data = snapshot.data();

      double currentBalance = 0.0;

      if (data != null && data['walletBalance'] is num) {
        currentBalance =
            (data['walletBalance'] as num).toDouble();
      }

      if (currentBalance < amount) {
        throw Exception('Insufficient wallet balance.');
      }

      final newBalance = currentBalance - amount;

      transaction.set(
        userDocument,
        {
          'walletBalance': newBalance,
        },
        SetOptions(merge: true),
      );

      return newBalance;
    });
  }

  /// Pay for a product/order.
  ///
  /// Returns the remaining wallet balance.
  static Future<double> pay(double amount) async {
    if (amount <= 0) {
      throw Exception('Invalid payment amount.');
    }

    final userDocument = _userDocument;

    return _firestore.runTransaction<double>((transaction) async {
      final snapshot = await transaction.get(userDocument);

      final data = snapshot.data();

      double currentBalance = 0.0;

      if (data != null && data['walletBalance'] is num) {
        currentBalance =
            (data['walletBalance'] as num).toDouble();
      }

      if (currentBalance < amount) {
        throw Exception(
          'Insufficient wallet balance. '
              'Please add money to your wallet.',
        );
      }

      final newBalance = currentBalance - amount;

      transaction.set(
        userDocument,
        {
          'walletBalance': newBalance,
        },
        SetOptions(merge: true),
      );

      return newBalance;
    });
  }
}