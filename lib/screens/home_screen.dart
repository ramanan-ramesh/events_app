import 'package:events_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:events_app/blocs/authentication_bloc/authentication_event.dart';
import 'package:events_app/blocs/events_bloc/events.dart';
import 'package:events_app/repositories/events_repository/events_repository.dart';
import 'package:events_app/widgets/event_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/create_event.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events!'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            },
          )
        ],
      ),
      body: BlocProvider<EventsBloc>(
        create: (context) {
          return EventsBloc(
            eventsRepository: FirebaseEventsRepository(),
          )..add(
              LoadEvents(),
            );
        },
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is EventsLoaded) {
              return Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) => EventTile(
                      event: state.events.elementAt(index),
                    ),
                    physics: BouncingScrollPhysics(),
                    itemCount: state.events.length,
                  ),
                ),
              );
            } else if (state is EventsLoading) {
              return Text('Events loading');
            } else if (state is EventsUpdated) {
              return Text('Events updated');
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: RawMaterialButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateEventPage(
                eventsRepository: FirebaseEventsRepository(),
              ),
            ),
          );
        },
        elevation: 2.0,
        fillColor: Colors.blue,
        child: Icon(
          Icons.add,
          size: 35.0,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }
}
