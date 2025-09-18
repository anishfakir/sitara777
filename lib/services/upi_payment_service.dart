import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:uuid/uuid.dart';

class UpiPaymentService {
  static const String upiId = "your-upi-id@upi"; // Replace with your actual UPI ID
  static const String merchantName = "Sitara777";
  
  // Launch UPI payment intent
  static Future<bool> launchUpiPayment({
    required double amount,
    required String remark,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    try {
      // Check if UPI apps are available
      final List<ApplicationMeta> appMetaList = await UpiPay.getInstalledUpiApplications(
        status: UpiApplicationDiscoveryStatus.All,
      );
      
      if (appMetaList.isEmpty) {
        // Fallback to URL scheme if no UPI apps found
        return _launchUpiUrl(amount: amount, remark: remark);
      }
      
      // Generate a unique transaction ID
      final String transactionId = Uuid().v4();
      
      // Launch UPI payment
      final UpiResponse response = await UpiPay.initiateTransaction(
        app: appMetaList[0].application, // Use the first available UPI app
        receiverUpiId: upiId,
        receiverName: merchantName,
        transactionRefId: transactionId,
        amount: amount,
        transactionNote: remark,
        merchantCode: '1234', // Optional merchant code
      );
      
      if (response.status == UpiPaymentStatus.success) {
        onSuccess();
        return true;
      } else {
        onFailure();
        return false;
      }
    } catch (e) {
      // Fallback to URL scheme if UPI plugin fails
      return _launchUpiUrl(amount: amount, remark: remark);
    }
  }
  
  // Fallback method using URL scheme
  static Future<bool> _launchUpiUrl({
    required double amount,
    required String remark,
  }) async {
    // UPI URL scheme
    final Uri upiUri = Uri.parse(
      'upi://pay?pa=$upiId&pn=$merchantName&am=$amount&tn=$remark&cu=INR'
    );
    
    if (await canLaunchUrl(upiUri)) {
      await launchUrl(upiUri);
      return true;
    } else {
      return false;
    }
  }
  
  // Validate UPI transaction ID format
  static bool isValidUpiTransactionId(String transactionId) {
    // Basic validation - UPI transaction IDs are usually alphanumeric
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(transactionId);
  }
}    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(transactionId);
  }
}