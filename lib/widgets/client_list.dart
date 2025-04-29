import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:slp_notebook/models/client.dart';
import 'package:slp_notebook/pages/client_page.dart';

class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => _ClientState();
}

class _ClientState extends State<ClientList> {
  Future<List<Client>>? futureClients;
  final database = SlpNotebookDb();

  @override
  void initState() {
    super.initState();

    fetchClients();
  }

  void fetchClients() {
    setState(() {
      futureClients = database.getAllClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const headerHeight = 46.0;
        var clientListHeight = max(constraints.maxHeight - headerHeight, 0).toDouble();
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: headerHeight,
                child: Text('clients',
                  style: TextStyle( fontSize: 32, fontWeight: FontWeight.bold, )
                ),
              ),
              FutureBuilder<List<Client>>(
                future: futureClients,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }else {
                    final clients = snapshot.data!;
                    if (clients.isEmpty) {
                      return const Text("No Clients");
                    }else {
                      List<Widget> clientListItems = [];
                      for (var element in clients) {
                        clientListItems.add(ListTile(
                          leading: CircleAvatar(
                              child: Text(
                                  element.name.substring(0, 1).toUpperCase())),
                          title: Text(element.name),
                          trailing: const Icon(Icons.more_vert),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ClientPage(
                                  title: 'Client', clientId: element.id);
                            })).then((value) {fetchClients();});
                          },
                        ));
                      }
                      return Container(
                        constraints: BoxConstraints( minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: clientListHeight),
                        child: ListView(
                            padding: const EdgeInsets.only(bottom: 80),
                            children: clientListItems),
                      );
                    }
                  }
                }
              ),
            ],
          )
        );
      }
    );
  }
}
