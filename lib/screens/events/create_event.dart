import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/repositories/events_repository/events_repository.dart';
import 'package:events_app/repositories/events_repository/src/firebase_events_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CreateEventPage extends StatelessWidget {
  final TextEditingController _nameFormController = TextEditingController();
  final TextEditingController _descriptionFormController =
      TextEditingController();
  File _mySelectedImageFile;
  final FirebaseEventsRepository eventsRepository;
  Timestamp _myTimeStamp = Timestamp.now();

  CreateEventPage({@required this.eventsRepository});

  void updateImage(File imageFile) {
    _mySelectedImageFile = imageFile;
  }

  void updateTimeStamp(Timestamp timestamp) {
    _myTimeStamp = timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Create Event'),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: _ImagePicker(
                updateSelectedFile: updateImage,
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
                        child: TextFormField(
                          controller: _nameFormController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            icon: Icon(Icons.event),
                            labelText: "Event Name",
                          ),
                          validator: (_) {
                            return _nameFormController.text.isEmpty
                                ? 'Event name is empty'
                                : null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextFormField(
                          controller: _descriptionFormController,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            icon: Icon(Icons.description),
                            labelText: "Event Description",
                          ),
                          validator: (_) {
                            return _descriptionFormController.text.isEmpty
                                ? 'Event description is empty'
                                : null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0),
                          shape: BoxShape.rectangle,
                        ),
                        child:
                            _DateTimePicker(updateTimeStamp: updateTimeStamp),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () async {
                        var partialEvent = PartialEvent(
                            name: _nameFormController.text,
                            description: _descriptionFormController.text,
                            dateTime: _myTimeStamp,
                            image: _mySelectedImageFile == null
                                ? null
                                : _mySelectedImageFile.absolute.path);
                        if (partialEvent.description.isNotEmpty &&
                            partialEvent.name.isNotEmpty) {
                          eventsRepository.addNewEvent(partialEvent);
                        }
                      },
                      child: Container(
                        color: Colors.red[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Text(
                                'Create Event',
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

class _ImagePicker extends StatefulWidget {
  final Function(File) updateSelectedFile;
  _ImagePicker({@required this.updateSelectedFile});

  @override
  __ImagePickerState createState() => __ImagePickerState();
}

class __ImagePickerState extends State<_ImagePicker> {
  File _mySelectedImageFile;

  void retrieveAndUpdateImage() async {
    var pickedFile = await _getFromGallery();
    if (_mySelectedImageFile != pickedFile) {
      setState(() {
        _mySelectedImageFile = pickedFile;
        widget.updateSelectedFile(_mySelectedImageFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FittedBox(
          child: Image(
            image: _mySelectedImageFile == null
                ? AssetImage('images/default_event_poster.jpg')
                : FileImage(_mySelectedImageFile),
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: FloatingActionButton.extended(
            onPressed: retrieveAndUpdateImage,
            label: Text('Select Image'),
            icon: Icon(Icons.photo_size_select_actual_outlined),
          ),
        ),
      ],
    );
  }

  Future<File> _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}

class _DateTimePicker extends StatefulWidget {
  final Function(Timestamp) updateTimeStamp;
  _DateTimePicker({@required this.updateTimeStamp});

  @override
  __DateTimePickerState createState() => __DateTimePickerState();
}

class __DateTimePickerState extends State<_DateTimePicker> {
  Timestamp _myTimeStamp = Timestamp.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _myTimeStamp = Timestamp.fromDate(picked);
        widget.updateTimeStamp(_myTimeStamp);
      });
  }

  String getDateFormat(DateTime dateTime) {
    return dateTime.day.toString() +
        ' ' +
        DateFormat.MMMM().format(dateTime) +
        ', ' +
        dateTime.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              getDateFormat(
                _myTimeStamp.toDate(),
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                await _selectDate(context);
              },
              label: Text('Update Date'),
              icon: Icon(Icons.date_range),
            ),
          ],
        ),
      ),
    );
  }
}
