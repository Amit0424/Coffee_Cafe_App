import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addMakingTimeFieldToAllDocuments() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collection = firestore.collection('products');

  // Retrieve all documents in the collection
  QuerySnapshot querySnapshot = await collection.get();

  // Firestore write batch for efficient multi-document updates
  WriteBatch batch = firestore.batch();

  // Random number generator
  // Random random = Random();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    // Generate a random number between 10 and 20 for the makingTime
    // random.nextInt(11) + 10; // This generates a number between 0-10 and then adds 10
    // Prepare to update the document with the new makingTime field
    batch.update(doc.reference, {'rating': []});
  }

  // Commit the batch
  await batch.commit().then((_) {}).catchError((error) {});
}

Future<void> removeFieldFromAllDocuments() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Reference to your collection
  final CollectionReference collection = firestore.collection('products');

  // Fetch all documents in the collection
  final QuerySnapshot querySnapshot = await collection.get();

  // Iterate over all documents
  for (var doc in querySnapshot.docs) {
    // Update each document to remove the specified field
    await doc.reference.update({
      'favoritesUsersList': FieldValue.delete(),
    });
  }
}
