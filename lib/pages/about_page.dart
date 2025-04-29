import 'package:flutter/material.dart';
import 'package:slp_notebook/widgets/app_navigation_drawer.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.title});

  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const AppNavigationDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'about',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )
            ),
            Padding(
              padding:EdgeInsets.all(16.0),
              child: Text('There is not a whole lot to say yet. This is still very much under development')
            )
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
