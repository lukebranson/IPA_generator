import 'package:flutter/material.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:slp_notebook/models/client.dart';
import 'package:slp_notebook/models/session.dart';
import 'package:slp_notebook/pages/session_page.dart';

class ClientTabSessions extends StatefulWidget {
  final Client client;
  const ClientTabSessions({super.key, required this.client});

  @override
  State<ClientTabSessions> createState() => _ClientTabSessionsState();
}

class _ClientTabSessionsState extends State<ClientTabSessions> {
  Future<List<Session>>? futureSessions;
  final database = SlpNotebookDb();

  @override
  void initState() {
    super.initState();

    fetchSessions();
  }

  void fetchSessions() {
    setState(() {
      futureSessions = database.getSessionsByClientId(widget.client.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Session>>(
      future: futureSessions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }else{
          final sessions = snapshot.data!;
          List<Widget> sessionTiles = [];
          if(sessions.isEmpty){
            sessionTiles.add(const Center(child: Text("No Sessions Yet")));
          }
          for(Session session in sessions){
            var date = DateTime.fromMillisecondsSinceEpoch(session.createDate);
            sessionTiles.add(
              ListTile(
                title: Text("${date.month}/${date.day}/${date.year}"),
                trailing: IconButton(
                  onPressed: () async {
                    bool delete = await showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text('Please Confirm'),
                          content: const Text('Are you sure to delete this session? This is irreversable.'),
                          actions: [
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () {Navigator.of(context).pop(true);},
                            ),
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {Navigator.of(context).pop(false);},
                            )
                          ]
                        );
                      }
                    );
                    if(!delete){
                      return;
                    }
                    await database.deleteSessionById(session.id).then((erg){
                      fetchSessions();
                    });
                  },
                  icon: const Icon(Icons.delete)
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return SessionPage(sessionId: session.id);
                  }));
                },
              )
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12, top: 20),
            children: [
              FilledButton.tonal(
                onPressed: () { 
                  database.insertSession(clientId: widget.client.id, createDate: DateTime.now().millisecondsSinceEpoch).then((newSessionId) {
                    if(context.mounted){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SessionPage(sessionId: newSessionId);
                      })).then((result){
                        fetchSessions();
                      });
                    }
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child:  Center(
                    child: Text('+ New Session'),
                  )
                )
              ),
              ...sessionTiles
            ]
          );
        }
      }
    );
  }
}
