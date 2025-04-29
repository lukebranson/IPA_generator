import 'package:flutter/material.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:slp_notebook/models/client.dart';
import 'package:slp_notebook/models/goal.dart';

class ClientTabStats extends StatefulWidget {
  final Client client;
  const ClientTabStats({super.key, required this.client});

  @override
  State<ClientTabStats> createState() => _ClientTabStatsState();
}

class _ClientTabStatsState extends State<ClientTabStats> {
  Future<List<Goal>>? futureGoals;
  final database = SlpNotebookDb();
  final newGoalNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchGoals();
  }

  void fetchGoals() {
    setState(() {
      futureGoals = database.getGoalsByClientId(clientId: widget.client.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Goal>>(
      future: futureGoals,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }else{
          final goals = snapshot.data ?? [];
          List<Widget> goalTiles = [];
          if(goals.isEmpty){
            goalTiles.add(const Center(child: Text("No Goals Yet")));
          }
          for(Goal goal in goals){
            goalTiles.add(
              ListTile(
                title: Text(goal.name),
                trailing: const Icon(Icons.more_vert),
                onTap: () {
                  
                },
              )
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12, top: 20),
            children: [
              ...goalTiles,
              FilledButton.tonal(
                onPressed: () { 
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => 
                    AlertDialog(
                      title:Text("New Goal"),
                      content:TextFormField(
                        controller: newGoalNameController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          hintText: 'Goal Name',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            database.insertGoal(clientId: widget.client.id, name:newGoalNameController.text).then((newGoalId) {
                              newGoalNameController.text = "";
                              if(context.mounted){
                                Navigator.pop(context,'OK');
                                fetchGoals();
                              }
                            });
                          },
                          child: const Text('OK'),
                        ),
                      ]
                    )
                    
                  ).then((result){
                    fetchGoals();
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child:  Center(
                    child: Text('+ New Goal'),
                  )
                )
              ),
            ]
          );
        }
      }
    );
  }
}
