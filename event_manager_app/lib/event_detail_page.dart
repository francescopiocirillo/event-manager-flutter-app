import 'package:fl_chart/fl_chart.dart';
import  'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thirty_green_events/event.dart';
import 'package:thirty_green_events/person.dart';

class EventDetailPage extends StatelessWidget {

  final Event event; 
  
  const EventDetailPage({super.key, required this.event});

  /**Questa pagina mostra tutti i dettagli relativi all'evento d'interesse.
   * Si può selezionare l'evento cliccando sulle card della dashboard e 
   * della schermata Gestione evento. Si naviga per stack.
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text(event.title, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 30, 
              color: Colors.teal.shade900 ),
                     ),
        ),
        body: SafeArea(
          /**La Safearea contiene tutte le informazioni, esse sono divise
           * in quattro sezioni delimitate dai divider
           */
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: (MediaQuery.of(context).orientation == Orientation.portrait ?
                    200 : 100),
                  width: MediaQuery.of(context).size.width * 1,
                  child: Image.asset(event.img, fit: BoxFit.cover),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary, 
                      width: 15, 
                    ),
                  ),
                ),
                /**prima sezione: le date e l'orario dell'evento disposti in orizzontale*/
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
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
                /**seconda sezione: descrizione dell'evento */
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(event.description, textAlign: TextAlign.center),
                ),
                Divider(color: Colors.teal.shade100,
                            thickness: 2.0,),
                /**terza sezione: grafico a torta che mostra la ercentuale di completamento
                 *dei partecipanti con relativi numeri informativi*/
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
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
                          /**i SizedBox evitano l'Overflow per i grafici della libreria flchart  */
                      width: 150,
                      height: 150,
                      child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 40.0,
                        sectionsSpace: 2.0,
                        sections: [
                          PieChartSectionData(
                            showTitle: false,
                            radius: 10,
                            value: (event.expectedParticipants - event.actualParticipants).toDouble(),
                            color: Colors.teal[100],),
                          PieChartSectionData(
                            gradient: SweepGradient(
                              colors: [
                                Colors.tealAccent.shade700,
                                Colors.tealAccent.shade100,
                              ],
                            ),
                            radius: 15,
                            value: event.actualParticipants.toDouble(),  
                            title: '${(event.actualParticipants / (event.expectedParticipants) * 100).toStringAsFixed(1)}%'),],
                      ),
                    ),
                  ),
                  const Text('percentage of registered participants'),
                  ],
                  ),
                ),
                Divider(color: Colors.teal.shade100,
                            thickness: 2.0,),
                /**quarta sezione: 
                 * - se ci sono partecipanti registrati sono mostrati in questa sezione 
                 *    con i relativi CircleAvatar,
                 * - se l'evento non ha partecipanti attivi viene mostrata una frase di riempiento
                 */
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                      child: Text( (event.participants.isEmpty ? 
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
                ListView.builder(
                    shrinkWrap: true, /*listView occuperebbe tutto lo spazio disponibile nella SingleChildScrollView, 
                      questo rigo riduce la lunghezza della lista esattamente a quella dei componenti che contiene*/
                    physics: const NeverScrollableScrollPhysics(), /*non si può scrollarre la lista, si scrolla 
                      solo l'intera pagina altimenti se si era in fondo alla schermata e la lista era abbastanza 
                      lunga da occupare tutta l'altezza non si aveva più modo di scrollare l'intera schermata per 
                      tornare in cima ma si poteva scrollare solo la lista rimanendo bloccati*/
                    itemCount: event.participants.length,
                    itemBuilder: (context, index) {
                      Person persona = event.participants[index]; 
                      return ListTile(
                        /**l'elenco è scandito da dei cerchi che contengono l'iniziale del nome dell'invitato */
                        leading: CircleAvatar(
                          child: Text(persona.name[0]),
                        ),
                        title: Text("${persona.name} ${persona.lastName}"),
                        subtitle: Text(DateFormat("yMd").format(persona.birth)),
                      );
                    },
                )
              ],
            ),
            
          ),
        ),
      );
  }
}