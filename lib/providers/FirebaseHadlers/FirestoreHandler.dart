import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreHandler extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get firestoreInstance {
    return _firestore;
  }

  Future<DocumentReference> addDocumentToCollection(
      String collectionName, Map<String, dynamic> document) async {
    try {
      final doc = await _firestore.collection(collectionName).add(document);
      return doc;
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> addDocumentToCollectionById(
      String collectionName, String id, Map<String, dynamic> document) async {
    try {
      final doc =
          await _firestore.collection(collectionName).doc(id).set(document);
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot> getDocumentsListSnapshot(String collectionName,
      [DocumentSnapshot lastDocSnapshot = null]) async {
    Query query;

    if (lastDocSnapshot == null) {
      query =
          _firestore.collection(collectionName).orderBy("timestamp",descending: true).limit(3);
    } else {
      query = _firestore
          .collection(collectionName)
          .orderBy("timestamp",descending: true)
          .limit(3)
          .startAfterDocument(lastDocSnapshot);
    }

    try {
      final querySnapshot = query.get();
      print('Calling Firestore');
      return querySnapshot;
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<DocumentReference> getDocumentReference(
      String collectionName, String docId) async {
    try {
      final querySnapshot =
          await _firestore.collection(collectionName).doc(docId);
      return querySnapshot;
    } on Exception catch (e) {
      print(e);
    }
  }

  Stream<DocumentSnapshot> documentListener(
      String collectionName, String documentId) {
    return _firestore.collection(collectionName).doc(documentId).snapshots();
  }

  Stream<QuerySnapshot> queryListener(String collectionName) {
    return _firestore.collection(collectionName).get().asStream();
  }

  Future<void> updateDocById(String collectionName, String docId, String field,
      [int increment = 0]) async {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docId)
        .update({field: FieldValue.increment(increment)});
  }

  Future<int> getMeta() async {
    final list = await _firestore.collection('metadata').get();
    return list.docs.first.data()["noOfPosts"];
  }

  Future<void> setMeta() async {
    final list = await _firestore
        .collection('metadata')
        .doc("l09loZ8FjuNnbqQl7OpQ")
        .update({'noOfPosts': FieldValue.increment(1)});
  }
}

// {
//       'username': 'user4',
//       'imageUrl':
//           'https://images.pexels.com/photos/2170387/pexels-photo-2170387.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260',
//       'likes': 10,
//       'comments': 5,
//       'shares': 2,
//       'timestamp': DateTime.now(),
//     }
