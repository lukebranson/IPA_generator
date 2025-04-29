import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slp_notebook/models/goal.dart';
import 'package:slp_notebook/models/note.dart';

import '../database/slp_notebook_db.dart';

class AddEditNoteForm extends StatefulWidget {

  const AddEditNoteForm({required this.sessionId, required this.clientId, this.editNote, required this.onSubmitFunc,super.key});

  final int sessionId;
  final int clientId;
  final Note? editNote;
  final Function onSubmitFunc;

  @override
  State<AddEditNoteForm> createState() => _AddEditNoteFormState();
}

class _AddEditNoteFormState extends State<AddEditNoteForm> {
  Future<List<Goal>>? futureGoals;
  
  final bodyTextInputController = TextEditingController();
  final scoreNumeratorController = TextEditingController();
  final scoreDenominatorController = TextEditingController();
  int goalDropDownSelection = 0;
  final database = SlpNotebookDb();

  @override
  void initState() {
    super.initState();
    if(widget.editNote != null){
      bodyTextInputController.text = widget.editNote!.bodyText;
      scoreNumeratorController.text = widget.editNote!.scoreNumerator.toString();
      scoreDenominatorController.text = widget.editNote!.scoreDenominator.toString();
      goalDropDownSelection = widget.editNote!.goalId;
    }

    fetchGoals();
  }

  void fetchGoals() {
    setState(() {
      futureGoals = database.getGoalsByClientId(clientId: widget.clientId);
    });
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<List<Goal>>(
      future: futureGoals,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }else{
          final goals = snapshot.data ?? [];
          String titleText = 'Edit Note';
          if(widget.editNote == null){
            titleText = 'New Note';
          }
          return AlertDialog(
            title: Text(titleText),
            content: SizedBox(
              width:800,
              child:Column(
                children:[
                  DropdownButtonFormField(
                    hint:Text("select a goal (optional)"),
                    value: goalDropDownSelection == 0 ? null : goalDropDownSelection,
                    items: goals.map<DropdownMenuItem<int>>((Goal goal){
                      return DropdownMenuItem<int>(
                        value: goal.id,
                        child: Text(goal.name)
                      );
                    }).toList(),
                    onChanged:(value){
                      goalDropDownSelection = value ?? 0;
                    }
                  ),
                  TextFormField(
                    controller: bodyTextInputController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Notes / Description',
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: scoreNumeratorController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], 
                          decoration: const InputDecoration(
                            hintText: 'Successes',
                          ),
                        ),
                      ),
                      Text("  /  "),
                      Flexible(
                        child: TextFormField(
                          controller: scoreDenominatorController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], 
                          decoration: const InputDecoration(
                            hintText: 'Trials',
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if(widget.editNote == null){
                    database.insertNote(
                      sessionId: widget.sessionId,
                      goalId: goalDropDownSelection,
                      bodyText:bodyTextInputController.text,
                      scoreNumerator: scoreNumeratorController.text != "" ? int.parse(scoreNumeratorController.text) : 0,
                      scoreDenominator: scoreDenominatorController.text != "" ? int.parse(scoreDenominatorController.text) : 0,
                    ).then((newNoteId) {
                      if(context.mounted){
                        Navigator.pop(context,'OK');
                        widget.onSubmitFunc();
                      }
                    });
                  } else {
                    database.editNote(
                      noteId: widget.editNote!.id,
                      goalId: goalDropDownSelection,
                      bodyText:bodyTextInputController.text,
                      scoreNumerator: int.parse(scoreNumeratorController.text),
                      scoreDenominator: int.parse(scoreDenominatorController.text),
                    ).then((newNoteId) {
                      if(context.mounted){
                        Navigator.pop(context,'OK');
                        widget.onSubmitFunc();
                      }
                    });
                  }
                  
                },
                child: const Text('OK'),
              ),
            ]
          );
        }
      }
    );
    
  }
}