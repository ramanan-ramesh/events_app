import 'dart:async';

import 'models/event.dart';

abstract class EventsRepository {
  Future<Event> addNewEvent(PartialEvent partialEvent);

  Stream<List<Event>> events();

  Future<void> registerAttendee(Event event, String name);
}
