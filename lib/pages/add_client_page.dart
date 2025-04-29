import 'package:flutter/material.dart';
import 'package:slp_notebook/widgets/add_client_form.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key, required this.title});

  final String title;

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const AddClientForm(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
