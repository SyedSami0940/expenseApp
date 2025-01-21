import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/model/expense/expenseDash_detail_model.dart';

const String TITLE_Detail_collection = "dashTitle_detail_ref";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<DashTitleDetail> _titleCollection;

  DatabaseService() {
    _titleCollection = _firestore
        .collection(TITLE_Detail_collection)
        .withConverter<DashTitleDetail>(
          fromFirestore: (snapshot, _) {
            // Safer null handling
            final data = snapshot.data();
            if (data == null) {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                message: 'Document data was null',
              );
            }
            return DashTitleDetail.fromJson(data);
          },
          toFirestore: (dashTitle, _) => dashTitle.toJson(),
        );
  }

  /// Stream of all dashboard titles
  Stream<QuerySnapshot<DashTitleDetail>> getTitles() {
    try {
      return _titleCollection.snapshots();
    } catch (e) {
      print('Error getting titles stream: $e');
      rethrow;
    }
  }

  /// Add a new dashboard title
  Future<DocumentReference<DashTitleDetail>> addTitle(
      DashTitleDetail subTitle) async {
    try {
      return await _titleCollection.add(subTitle);
    } catch (e) {
      print('Error adding title: $e');
      rethrow;
    }
  }

  /// Delete a dashboard title by ID
  Future<void> deleteTitle(String titleId) async {
    try {
      await _titleCollection.doc(titleId).delete();
    } catch (e) {
      print('Error deleting title: $e');
      rethrow;
    }
  }

  /// Update a dashboard title
  Future<void> updateTitle(String titleId, DashTitleDetail subTitle) async {
    try {
      await _titleCollection.doc(titleId).set(subTitle);
    } catch (e) {
      print('Error updating title: $e');
      rethrow;
    }
  }

  /// Get a single dashboard title by ID
  Future<DashTitleDetail?> getTitleById(String titleId) async {
    try {
      final doc = await _titleCollection.doc(titleId).get();
      return doc.data();
    } catch (e) {
      print('Error getting title by ID: $e');
      rethrow;
    }
  }
}
