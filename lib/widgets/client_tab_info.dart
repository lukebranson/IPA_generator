import 'package:flutter/material.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:slp_notebook/models/client.dart';

class ClientTabInfo extends StatefulWidget {
  final Client client;
  const ClientTabInfo({super.key, required this.client});

  @override
  State<ClientTabInfo> createState() => _ClientTabInfoState();
}

class _ClientTabInfoState extends State<ClientTabInfo> {
  final database = SlpNotebookDb();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
      children: [

        //info header
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom:12, top: 12),
            child: Text('info', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, ))
          ),
        ),

        Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text ('Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                Padding(
                  padding: const EdgeInsets.only(bottom:12),
                  child: Text (widget.client.name, style: const TextStyle(fontSize: 18, )),
                ),

                //Description
                const Text ('Notes / Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                Padding(
                  padding: const EdgeInsets.only(bottom:12),
                  child: Text (
                    widget.client.description != "" ? widget.client.description : "[no notes available. click edit to add some]",
                    style: TextStyle(fontSize: 18, fontStyle: (widget.client.description == "" ? FontStyle.italic : FontStyle.normal))
                  ),
                ),

                //Birthday
                const Text ('Birthday', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                Padding(
                  padding: const EdgeInsets.only(bottom:12),
                  child: Builder(
                    builder: (context) {
                      var bday = DateTime.fromMillisecondsSinceEpoch(widget.client.birthday);
                      return Text ("${bday.month}/${bday.day}/${bday.year}", style: const TextStyle(fontSize: 18, ));
                    }
                  )
                ),

                //Age
                const Text ('Age', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                Padding(
                  padding: const EdgeInsets.only(bottom:12),
                  child: Builder(
                    builder: (context) {
                      var milliseconddiff = DateTime.now().millisecondsSinceEpoch - widget.client.birthday;
                      //calculate age (figure out something better later. doesn't count leap years)
                      var year = milliseconddiff/(1000*60*60*24*365);
                      return Text (year.floor().toString(), style: const TextStyle(fontSize: 18, ));
                    }
                  )
                ),
              ],
            ),
          )
        ),
        

        //manage header
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom:12, top: 30),
            child: Text('manage', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, ))
          ),
        ),

        //delete client
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom:12, top: 12),
            child: FilledButton(
              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.red)),
              onPressed: () async {
                bool delete = await showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text('Please Confirm'),
                      content: const Text('Are you sure to delete this client? All client data will be lost forever.'),
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
                await database.deleteClientById(widget.client.id).then((erg){
                  if(context.mounted){
                    Navigator.pop(context);
                  }
                });
              },
              child: const Text('delete client')),
          ),
        ),
    ]);
  }
}
