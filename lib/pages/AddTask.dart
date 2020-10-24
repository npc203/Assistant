import 'package:flutter/material.dart';
import 'package:Assistant/database.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  Task newTask = Task();
  @override
  Widget build(BuildContext context) {
    List<String> ping = ["high", "medium", "low"];
    return Scaffold(
        //drawer: NavBar(),
        appBar: AppBar(
          title: Text('Add Task'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(50, 70, 50, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Give the Name of your Task',
                    labelText: 'Title *',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (String value) => setState(() {
                    newTask.task = value;
                  }),
                ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    hintText: 'Description of your task',
                    labelText: 'Description',
                  ),
                  onSaved: (String value) => {
                    setState(() {
                      newTask.description = value;
                    }),
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 70, 10),
                  child: DropdownButtonFormField(
                    //onTap: () => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(hintText: "Ping"),
                    items: ping.map((String category) {
                      return new DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.star),
                              Text(category),
                            ],
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => newTask.ping = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        var form = _formKey.currentState;
                        form.save();
                        newTask.time = DateTime.now().toString();
                        DatabaseHelper().insertTask(newTask);
                        Navigator.pushReplacementNamed(context, '/task',
                            arguments: true);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
