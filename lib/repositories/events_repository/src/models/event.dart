import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Event {
  final String id;
  static const String _attendees = 'attendees';
  final List<String> attendees;
  final PartialEvent partialEvent;

  Event({
    @required this.id,
    @required this.partialEvent,
    List<String> attendees,
  }) : this.attendees = attendees ?? [];

  Event copyWith({List<String> attendees}) {
    return Event(
        id: this.id,
        partialEvent: this.partialEvent,
        attendees: attendees ?? this.attendees);
  }

  Map<String, Object> toJson() {
    var consolidatedMap = partialEvent.toJson();
    consolidatedMap.addAll({_attendees: this.attendees});
    return consolidatedMap;
  }

  static Event fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    if (data == null) throw Exception();
    return Event(
      id: snap.id,
      partialEvent: PartialEvent.fromSnapshot(snap),
      attendees: data.containsKey(_attendees)
          ? List<String>.from(data[_attendees])
          : [],
    );
  }
}

class PartialEvent {
  final String name;
  static const String _name = 'name';
  final String description;
  static const String _description = 'description';
  final Timestamp dateTime;
  static const String _dateTime = 'dateTime';
  String image;
  static const String _image = 'image';

  PartialEvent(
      {@required this.name,
      @required this.description,
      @required this.dateTime,
      this.image});

  Map<String, Object> toJson() {
    return {
      _name: this.name,
      _description: this.description,
      _dateTime: this.dateTime,
      _image: this.image
    };
  }

  static PartialEvent fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    if (data == null) throw Exception();
    return PartialEvent(
        name: data[_name] as String,
        description: data[_description] as String,
        dateTime: data[_dateTime] as Timestamp,
        image: data[_image] as String);
  }
}
