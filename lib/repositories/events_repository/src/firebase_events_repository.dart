import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'events_repository.dart';
import 'models/event.dart';

class FirebaseEventsRepository implements EventsRepository {
  final eventCollection = FirebaseFirestore.instance.collection('events');
  final imagesCollection = FirebaseStorage.instance.ref('eventImages');

  Reference _calculatePathToStorage() {
    var userEmail = FirebaseAuth.instance.currentUser.email;
    userEmail = userEmail.substring(0, userEmail.indexOf('@'));
    return imagesCollection.child(userEmail).child(DateTime.now().toString());
  }

  @override
  Future<Event> addNewEvent(PartialEvent partialEvent) async {
    if (partialEvent.image != null) {
      var imageAddOperationResult = await _calculatePathToStorage().putFile(
        File(partialEvent.image),
      );
      partialEvent.image = await imageAddOperationResult.ref.getDownloadURL();
    }
    var addOperationResult = await eventCollection.add(partialEvent.toJson());
    return Event(id: addOperationResult.id, partialEvent: partialEvent);
  }

  @override
  Stream<List<Event>> events() {
    return eventCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> registerAttendee(Event event, String name) {
    if (!event.attendees.contains(name)) {
      event.attendees.add(name);
    }
    return eventCollection.doc(event.id).update(event.toJson());
  }
}
