import 'package:flutter/material.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:slp_notebook/models/client.dart';
import 'package:slp_notebook/models/note.dart';
import 'package:slp_notebook/models/session.dart';
import 'package:slp_notebook/widgets/add_edit_note_form.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key, required this.sessionId});

  final int sessionId;
  final String title = "Session";

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Future<Client>? futureClient;
  Future<Session>? futureSession;
  Future<List<Note>>? futureNotes;
  final database = SlpNotebookDb();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData(){
    setState(() {
      futureSession = database.getSessionById(widget.sessionId);
      futureSession!.then((session){
        futureClient = database.getClientById(session.clientId);
      });
      futureNotes = database.getNotesBySessionId(sessionId: widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: futureSession,
        builder: ( context,  snapshot, ) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Text("Loading");
          }else {
            final currentSession = snapshot.data!;
            return FutureBuilder(
              future: futureClient,
              builder: ( context, snapshot ) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                } else {
                  final currentClient = snapshot.data!;
                  var createDate = DateTime.fromMillisecondsSinceEpoch(currentSession.createDate);
                  final createDateText = "${createDate.month}/${createDate.day}/${createDate.year}";
                  return LayoutBuilder(
                    builder:(BuildContext context, BoxConstraints constraints) {
                      final maxHeight = constraints.maxHeight;
                      return Center(
                        child:Container(
                          constraints: BoxConstraints( minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: maxHeight),
                          child:FutureBuilder<List<Note>>(
                            future: futureNotes,
                            builder:(context, snapshot) {
                              List<Widget> listViewItems = [];
                              listViewItems.add(
                                Center(
                                    child: Column(
                                      children: [
                                        Text(currentClient.name,
                                          style: const TextStyle( fontSize: 32, fontWeight: FontWeight.bold)
                                        ),
                                        Text(createDateText,
                                          style: const TextStyle( fontSize: 24, fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                    ),
                                  )
                              );
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                listViewItems.add(const Text("Loading..."));
                              }else{
                                final notes = snapshot.data!;
                                for (Note note in notes){
                                  listViewItems.add(
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) => AddEditNoteForm(sessionId: widget.sessionId, clientId: currentClient.id, editNote: note, onSubmitFunc: fetchData,),
                                        );
                                      },
                                      child: Card(
                                        child:Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top:8.0, bottom: 8.0),
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder(
                                                future: database.getGoalById(goalId: note.goalId),
                                                builder: (goalContext,  goalSnapshot){
                                                  if(goalSnapshot.connectionState == ConnectionState.waiting) {
                                                    return const Text("Loading Goal...");
                                                  }else{
                                                    if(goalSnapshot.hasData){
                                                      final goalById = goalSnapshot.data!;
                                                      return Text(goalById.name, style:TextStyle(fontWeight: FontWeight.bold));
                                                    }else {
                                                      return Text("plain note", style:TextStyle(fontWeight: FontWeight.bold));
                                                    }
                                                  }
                                                }
                                              ),
                                              
                                              Text(note.bodyText),
                                              if(note.scoreDenominator != 0)
                                                Align(
                                                  alignment: Alignment.bottomRight,
                                                  child:Text(
                                                    style:TextStyle(fontSize: 16, fontWeight:FontWeight.bold),
                                                    "${note.scoreNumerator}/${note.scoreDenominator} (${(note.scoreNumerator/note.scoreDenominator*100).toStringAsFixed(2)}%)"
                                                  ),
                                                )
                                            ],
                                          )
                                        )
                                      )
                                    )
                                  );
                                }
                                listViewItems.add(FilledButton.tonal(
                                  onPressed: () { 
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AddEditNoteForm(sessionId: widget.sessionId, clientId: currentClient.id, onSubmitFunc: fetchData,),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    child:  Center(
                                      child: Text('+ Add Note'),
                                    )
                                  )
                                ));
                              }
                              return ListView(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                                children:listViewItems,
                              );
                            }
                          )
                        )
                      );
                      
                    } 
                    
                  );
                }
              }
            );
          }
        }
      )
    );
  }
}
