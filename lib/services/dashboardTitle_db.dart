import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenseapp/model/expense/expenseDash_model.dart';

const String DASHBOARD_TITLE_COLLECTION = "DB_Title_ref";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<DashboardTitle> _titleCollection;

  DatabaseService() {
    _titleCollection = _firestore
        .collection(DASHBOARD_TITLE_COLLECTION)
        .withConverter<DashboardTitle>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data == null) {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                message: 'Document data was null',
              );
            }
            return DashboardTitle.fromJson(data);
          },
          toFirestore: (dashTitle, _) => dashTitle.toJson(),
        );
  }

  /// Stream of all dashboard titles
  Stream<QuerySnapshot<DashboardTitle>> getTitles() {
    return _titleCollection.snapshots();
  }

  /// Add a new dashboard title
  Future<DocumentReference<DashboardTitle>> addTitle(
      DashboardTitle title) async {
    return await _titleCollection.add(title);
  }

  /// Delete a dashboard title by ID
  Future<void> deleteTitle(String titleId) async {
    await _titleCollection.doc(titleId).delete();
  }

  /// Update a dashboard title by ID
  Future<void> updateTitle(String titleId, String newTitle) async {
    final docRef = _titleCollection.doc(titleId);

    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Document with ID $titleId does not exist',
      );
    }

    await docRef.update({'title': newTitle});
  }

  /// Get a single dashboard title by ID
  Future<DashboardTitle?> getTitleById(String titleId) async {
    final doc = await _titleCollection.doc(titleId).get();
    return doc.data();
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expenseapp/model/expense/expenseDash_model.dart';

// const String DASHBOARD_TITLE_COLLECTION = "DB_Title_ref";

// class DatabaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late final CollectionReference<DashboardTitle> _titleCollection;

//   DatabaseService() {
//     _titleCollection = _firestore
//         .collection(DASHBOARD_TITLE_COLLECTION)
//         .withConverter<DashboardTitle>(
//           fromFirestore: (snapshot, _) {
//             // Safer null handling
//             final data = snapshot.data();
//             if (data == null) {
//               throw FirebaseException(
//                 plugin: 'cloud_firestore',
//                 message: 'Document data was null',
//               );
//             }
//             return DashboardTitle.fromJson(data);
//           },
//           toFirestore: (dashTitle, _) => dashTitle.toJson(),
//         );
//   }

//   /// Stream of all dashboard titles
//   Stream<QuerySnapshot<DashboardTitle>> getTitles() {
//     try {
//       return _titleCollection.snapshots();
//     } catch (e) {
//       print('Error getting titles stream: $e');
//       rethrow;
//     }
//   }

//   //edit for DashboardTitle
//   Future<void> updateTitle(String titleId, String newTitle) async {
//     await FirebaseFirestore.instance
//         .collection('dashboard_titles')
//         .doc(titleId)
//         .update({'title': newTitle});
//   }

//   /// Add a new dashboard title
//   Future<DocumentReference<DashboardTitle>> addTitle(
//       DashboardTitle title) async {
//     try {
//       return await _titleCollection.add(title);
//     } catch (e) {
//       print('Error adding title: $e');
//       rethrow;
//     }
//   }

//   /// Delete a dashboard title by ID
//   Future<void> deleteTitle(String titleId) async {
//     try {
//       await _titleCollection.doc(titleId).delete();
//     } catch (e) {
//       print('Error deleting title: $e');
//       rethrow;
//     }
//   }

//   // /// Update a dashboard title
//   // Future<void> updateTitle(String titleId, DashboardTitle title) async {
//   //   try {
//   //     await _titleCollection.doc(titleId).set(title);
//   //   } catch (e) {
//   //     print('Error updating title: $e');
//   //     rethrow;
//   //   }
//   // }

//   /// Get a single dashboard title by ID
//   Future<DashboardTitle?> getTitleById(String titleId) async {
//     try {
//       final doc = await _titleCollection.doc(titleId).get();
//       return doc.data();
//     } catch (e) {
//       print('Error getting title by ID: $e');
//       rethrow;
//     }
//   }
// }

// // // The ref is firebace cloud fireStore name that u created
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:expenseapp/model/expense/expenseDash_model.dart';

// // const String DashboardTitle_COLLECTION_REF = "DB_Title_ref";

// // class DatabaseService {
// //   final _firestore = FirebaseFirestore.instance;

// //   late final CollectionReference _DB_Title_ref;

// //   DatabaseService() {
// //     _DB_Title_ref = _firestore
// //         .collection(DashboardTitle_COLLECTION_REF)
// //         .withConverter<DashboardTitle>(
// //             fromFirestore: (snapshots, _) => DashboardTitle.fromJson(
// //                   snapshots.data()!,
// //                 ),
// //             toFirestore: (dashTitle, _) => dashTitle.tojson());
// //   }
// //   // function allow to get todo database
// //   Stream<QuerySnapshot> getTodos() {
// //     return _DB_Title_ref.snapshots();
// //   }

// //   void addTitle(DashboardTitle dashTitle) async {
// //     _DB_Title_ref.add(dashTitle);
// //   }

// //   // void updateTodo(String dashTitleid, Dashboard_title dashTitle) {
// //   //   _DB_Title_ref.doc(dashTitleid).update(dashTitle.tojson());
// //   // }

// //   void deletedtitle(String dashTitleid) {
// //     _DB_Title_ref.doc(dashTitleid).delete();
// //   }
// // }
