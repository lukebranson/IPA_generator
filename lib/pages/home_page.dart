import 'package:flutter/material.dart';
import 'package:slp_notebook/pages/add_client_page.dart';
import 'package:slp_notebook/widgets/client_list.dart';
import 'package:slp_notebook/widgets/app_navigation_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "Home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const AppNavigationDrawer(),
      body: const ClientList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddClientPage(title: 'Add Client');
          })).then((value)=>setState((){}));
        },
        tooltip: 'Increment',
        icon: const Icon(Icons.add),
        label: const Text('New Client'),
      ),
    );
  }
}
