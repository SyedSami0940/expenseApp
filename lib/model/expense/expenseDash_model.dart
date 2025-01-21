import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardTitle {
  final String title;
  final Timestamp createdOn;

  DashboardTitle({
    required this.title,
    required this.createdOn,
  });

  factory DashboardTitle.fromJson(Map<String, dynamic> json) {
    return DashboardTitle(
      title: json['title'] as String? ?? '',
      createdOn: json['createdOn'] as Timestamp? ?? Timestamp.now(),
    );
  }

  DashboardTitle copyWith({
    String? title,
    Timestamp? createdOn,
  }) {
    return DashboardTitle(
      title: title ?? this.title,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createdOn': createdOn,
    };
  }

  @override
  String toString() {
    return 'DashboardTitle(title: $title, createdOn: $createdOn)';
  }
}
