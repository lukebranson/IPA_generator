import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slp_notebook/database/slp_notebook_db.dart';
import 'package:slp_notebook/pages/home_page.dart';

class AddClientForm extends StatefulWidget {
  const AddClientForm({super.key});

  @override
  State<AddClientForm> createState() => _AddClientFormState();
}

class _AddClientFormState extends State<AddClientForm> {

  final database = SlpNotebookDb();

  final _formKey = GlobalKey<FormState>(); 

  final nameInputController = TextEditingController();
  final birthYearInputController = TextEditingController();
  final birthMonthInputController = TextEditingController();
  final birthDateInputController = TextEditingController();
  final descriptionInputController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameInputController.dispose();
    descriptionInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(BuildContext context, BoxConstraints constraints) {
        const headerHeight = 46.0;
        var formHeight = constraints.maxHeight - headerHeight;
        if(formHeight < 0){
          formHeight = 0;
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: headerHeight,
                child: Text(
                  'new client',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )
                ), 
              ),
              Form(
                key: _formKey,
                child: Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 800, minHeight: 0, maxHeight: formHeight),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        controller: nameInputController,
                        decoration: const InputDecoration(
                          hintText: 'Client Name',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const Text(" "),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              controller: birthMonthInputController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], 
                              decoration: const InputDecoration(
                                hintText: 'Birth Month',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty || int.parse(value) > 12 || int.parse(value) < 1) {
                                  return 'Please enter a valid month';
                                }
                                return null;
                              },
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: birthDateInputController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], 
                              decoration: const InputDecoration(
                                hintText: 'Birth Day',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty || int.parse(value) > 31 || int.parse(value) < 1) {
                                  return 'Please enter a valid day';
                                }
                                return null;
                              },
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: birthYearInputController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ], 
                              decoration: const InputDecoration(
                                hintText: 'Birth Year',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid year';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const Text(" "),
                      TextFormField(
                        controller: descriptionInputController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Notes / Description',
                        ),
                      ),
                      const Text(" "),
                      TextButton(
                        onPressed: () async {
                          final bool isValid = _formKey.currentState?.validate() ?? false;
                          if(!isValid){
                            return;
                          }
                          var birthMonthNumber = double.parse(birthMonthInputController.text);
                          var birthDateNumber = double.parse(birthDateInputController.text);
                          var birthYearhNumber = double.parse(birthYearInputController.text);
                          var birthdayMillis = DateTime(birthYearhNumber.floor(),birthMonthNumber.floor(),birthDateNumber.floor()).millisecondsSinceEpoch;
                          await database
                            .insertClient(name:nameInputController.text, description:descriptionInputController.text, birthday: birthdayMillis)
                            .then((erg){
                              if(context.mounted){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const HomePage();
                                }));
                              }
                            });
                        },
                        child: const Text('Submit'),
                      )
                    ],
                  ),
                ),
              ),

              
            ],
          ),
        );
      }
    );
  }
}
