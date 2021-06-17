import 'package:events_app/repositories/events_repository/events_repository.dart';
import 'package:events_app/repositories/events_repository/src/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  EventDetails({@required this.event});

  String getDateFormat(DateTime dateTime) {
    return dateTime.day.toString() +
        ' ' +
        DateFormat.MMMM().format(dateTime) +
        ', ' +
        dateTime.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Hero(
            child: Text(event.partialEvent.name),
            tag: event.id + 'name',
          ),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
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
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Hero(
                          tag: event.id + 'description',
                          child: Text(
                            event.partialEvent.description,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    getDateFormat(
                                      event.partialEvent.dateTime.toDate(),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: VerticalDivider(
                              thickness: 2.0,
                              color: Colors.red[900],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Number of Attendees',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      event.attendees.length.toString(),
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () async {
                        var a = FirebaseEventsRepository();
                        await a.registerAttendee(
                            event, FirebaseAuth.instance.currentUser.email);
                      },
                      child: Container(
                        color: Colors.red[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Text(
                                'Attend Event',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
