import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class DashTitleDetail {
  final num TAmount;
  final String subTitle;
  final num amount;
  final Timestamp dateTime;

  DashTitleDetail({
    required this.TAmount,
    required this.subTitle,
    required this.amount,
    required this.dateTime,
  });

  // Create from Firestore
  factory DashTitleDetail.fromJson(Map<String, dynamic> json) {
    return DashTitleDetail(
      TAmount: json['TAmount'] ?? 0.0,
      subTitle: json['subTitle'] ?? '',
      amount: json['amount'] ?? 0.0,
      dateTime: json['dateTime'] ?? Timestamp.now(),
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toJson() {
    return {
      'subTitle': subTitle,
      'amount': amount,
      'dateTime': dateTime,
      'TAmount': TAmount,
    };
  }

  // Optional: Add a copyWith method for easy object duplication
  DashTitleDetail copyWith({
    String? subTitle,
    num? amount,
    Timestamp? createdOn,
    num? TAmount,
  }) {
    return DashTitleDetail(
      TAmount: TAmount ?? this.TAmount,
      subTitle: subTitle ?? this.subTitle,
      amount: amount ?? this.amount,
      dateTime: createdOn ?? this.dateTime,
    );
  }
}
