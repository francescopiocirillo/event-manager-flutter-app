import 'package:flutter/material.dart';
import 'package:thirty_green_events/person.dart';

class Event {
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startHour;
  int expectedParticipants;
  int actualParticipants;
  String img;
  List<Person> participants = [];

  Event(
      {required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.startHour,
      required this.expectedParticipants,
      required this.actualParticipants,
      required this.img,
      this.participants = const []});

  void setParticipants(List<Person> participants) {
    this.participants = participants;
  }

  Map<String, Object?> toMap() {
    return {'title': title, 'description': description, 'startDate': startDate.toString(), 
            'endDate': endDate.toString(), 'startHour': startHour.toString(), 'expectedParticipants': expectedParticipants, 
            'actualParticipants': actualParticipants, 'img': img};
  }

  @override
  String toString() {
    return 'Event{title: $title, description: $description, startDate: $startDate, endDate: $endDate, startHour: $startHour, expectedParticipants: $expectedParticipants, actualParticipants: $actualParticipants, img: $img}';
  }

}
