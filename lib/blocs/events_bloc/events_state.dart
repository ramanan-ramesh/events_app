import 'package:events_app/repositories/events_repository/src/models/event.dart';

abstract class EventsState {
  const EventsState();
}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<Event> events;

  const EventsLoaded([this.events = const []]);
}
