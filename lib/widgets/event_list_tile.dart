import 'dart:ui';

import 'package:events_app/repositories/events_repository/src/models/event.dart';
import 'package:events_app/screens/events/event_details.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  final Event event;
  EventTile({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        side: BorderSide(width: 2, color: Colors.black),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetails(
                event: event,
              ),
            ),
          );
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 150.0,
                  width: double.infinity,
                  child: Hero(
                    tag: event.id + 'image',
                    child: FittedBox(
                      child: Image(
                        image: event.partialEvent.image == null
                            ? AssetImage('images/default_event_poster.jpg')
                            : NetworkImage(event.partialEvent.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Hero(
                    tag: event.id + 'name',
                    child: Text(
                      event.partialEvent.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    event.attendees.length.toString() + ' Attending',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Hero(
                    tag: event.id + 'description',
                    child: Text(
                      event.partialEvent.description,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
