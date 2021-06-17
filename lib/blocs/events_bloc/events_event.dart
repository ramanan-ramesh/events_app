import 'package:events_app/repositories/events_repository/events_repository.dart';

abstract class EventsEvent {
  const EventsEvent();
}

class LoadEvents extends EventsEvent {}

class AddEvent extends EventsEvent {
  final PartialEvent event;

  const AddEvent(this.event);
}

class EventsUpdated extends EventsEvent {
  final List<Event> events;

  const EventsUpdated(this.events);
}
