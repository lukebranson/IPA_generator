import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:slp_notebook/models/client.dart';
import 'package:slp_notebook/widgets/client_tab_info.dart';
import 'package:slp_notebook/widgets/client_tab_sessions.dart';
import 'package:slp_notebook/widgets/client_tab_stats.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key, required this.title, required this.clientId});

  final String title;
  final int clientId;

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> with TickerProviderStateMixin {
  Future<Client>? futureClient;
  final database = SlpNotebookDb();

  @override
  void initState() {
    super.initState();

    fetchClient();
  }

  void fetchClient() {
    setState(() {
      futureClient = database.getClientById(widget.clientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            const headerHeight = 60.0;
            var bodyHeight = max(constraints.maxHeight - headerHeight, 0).toDouble();
            const tabheightGuess = 48;
            return FutureBuilder<Client>(
              future: futureClient,
              builder: ( context,  snapshot, ) {
                var clientTabController = TabController(length: 3, vsync: this);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                } else {
                  final currentClient = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        constraints: const BoxConstraints(minWidth: 100, maxWidth: 800, minHeight: headerHeight, maxHeight: headerHeight),
                        child: Text(currentClient.name,
                          style: const TextStyle( fontSize: 32, fontWeight: FontWeight.bold)
                        )
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: bodyHeight),
                        child: Column(
                          children: [
                            TabBar(
                              controller: clientTabController,
                              tabs: const [
                                Tab(icon: Icon(Icons.calendar_month_rounded)),
                                Tab(icon: Icon(Icons.trending_up)),
                                Tab(icon: Icon(Icons.info_outline)),
                              ],
                            ),
                            Container(
                              constraints: BoxConstraints(minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: max(bodyHeight - tabheightGuess, 0)),
                              child: TabBarView(
                                  controller: clientTabController,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: max(bodyHeight - tabheightGuess, 0)),
                                      child: ClientTabSessions(client: currentClient),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: max(bodyHeight - tabheightGuess, 0)),
                                      child: ClientTabStats(client:currentClient),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: max(bodyHeight - tabheightGuess, 0)),
                                      child: ClientTabInfo(client: currentClient),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          })
      ),
    );
  }
}
