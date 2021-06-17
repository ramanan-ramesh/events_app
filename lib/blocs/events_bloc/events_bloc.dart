import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:events_app/blocs/events_bloc/events.dart';
import 'package:events_app/repositories/events_repository/src/events_repository.dart';
import 'package:flutter/material.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository _eventsRepository;
  StreamSubscription _eventsSubscription;

  EventsBloc({@required EventsRepository eventsRepository})
      : _eventsRepository = eventsRepository,
        super(EventsLoading());

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    if (event is LoadEvents) {
      yield* _mapLoadEventsToState();
    } else if (event is AddEvent) {
      yield* _mapAddEventToState(event);
    } else if (event is EventsUpdated) {
      yield* _mapEventUpdateToState(event);
    }
  }

  Stream<EventsState> _mapLoadEventsToState() async* {
    _eventsSubscription?.cancel();
    _eventsSubscription = _eventsRepository.events().listen(
          (events) => add(EventsUpdated(events)),
        );
  }

  Stream<EventsState> _mapAddEventToState(AddEvent event) async* {
    _eventsSubscription?.pause();
    await _eventsRepository.addNewEvent(event.event);
    _eventsSubscription?.resume();
  }

  Stream<EventsState> _mapEventUpdateToState(EventsUpdated event) async* {
    yield EventsLoaded(event.events);
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }
}
