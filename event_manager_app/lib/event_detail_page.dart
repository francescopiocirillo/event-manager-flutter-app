import 'package:event_manager_app/home_page.dart';
import 'package:fl_chart/fl_chart.dart';
import  'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailPage extends StatelessWidget {
  final Event event; 
  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text(event.title, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 30, 
              color: Colors.teal.shade900 ),
                     ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: Image.asset(event.img, fit: BoxFit.cover),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.teal, 
                      width: 15, 
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(20) 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text('Start date:'),
                                  Text(DateFormat("dd MMM yy").format(event.startDate)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.tealAccent[700],
                              borderRadius: BorderRadius.circular(20) 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text('Start hour:'),
                                  Text(DateFormat('h:mm a').format(
                                    DateTime(1,1,1,event.startHour.hour,event.startHour.minute)
                                  ),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.tealAccent,
                              borderRadius: BorderRadius.circular(20) 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text('End date:'),
                                  Text(DateFormat("dd MMM yy").format(event.endDate)),
                                ],
                              ),
                            ),
                          ), 
                          
                        ],
                      ),
                ),
                Divider(color: Colors.teal.shade100,
                            thickness: 2.0,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(event.description, textAlign: TextAlign.center),
                ),
                Divider(color: Colors.teal.shade100,
                            thickness: 2.0,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(20) 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text('expected partecipant:'),
                                  Text(event.expectedParticipants.toString()),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.tealAccent,
                              borderRadius: BorderRadius.circular(20) 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text('actual partecipant:'),
                                  Text(event.actualParticipants.toString()),
                                ],
                              ),
                            ),
                          ), 
                          
                        ],
                      ),
                      SizedBox(
                    width: 150,
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 30.0,
                        sectionsSpace: 3.0,
                        sections: [
                          PieChartSectionData(value: event.expectedParticipants.toDouble(), title: '${(event.expectedParticipants / (event.expectedParticipants+event.actualParticipants) * 100).toStringAsFixed(1)}%', color: Colors.teal, /*, badgeWidget: */),
                          PieChartSectionData(value: event.actualParticipants.toDouble(), color: Colors.tealAccent, title: '${(event.actualParticipants / (event.expectedParticipants+event.actualParticipants) * 100).toStringAsFixed(1)}%'),],
                      ),
                    ),
                  ),
                  Text('percentage of registered participants'),
                  ],
                  ),
                  
                ),
                Divider(color: Colors.teal.shade100,
                            thickness: 2.0,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                      child: Text( (event.participants.length == 0 ? 
                          'The list of participants will be shown here when they are added' :
                          'List of participants'),
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 25, 
                          color: Colors.teal.shade900 ),
                      ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(), /*non si può scrollarre la lista, si scrolla solo l'intera pagina */
                      itemCount: event.participants.length,
                      itemBuilder: (context, index) {
                        Person persona = event.participants[index]; 
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(persona.name[0]),
                          ),
                          title: Text(persona.name + " " + persona.lastName),
                          subtitle: Text(DateFormat("yMd").format(persona.birth)),
                        );
                      },
                  ),
                )
              ],
            ),
            
          ),
        ),
      );
  }
}