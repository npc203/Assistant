import 'package:Assistant/pages/AddTask.dart';
import 'package:Assistant/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Assistant!',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/task': (context) => TaskPage(),
        '/Add': (context) => AddTask(),
      },
    );
  }
}

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> taskList;
  int count = 0;
  DatabaseHelper databaseHelper;
  var check = false;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    taskList = List<Task>();
  }

  @override
  Widget build(BuildContext context) {
    print("Build!");
    check = ModalRoute.of(context).settings.arguments;
    if (taskList.isEmpty || check == true) {
      print("refreginh!!$check");
      refreshList();
      check = false;
    }
    return Scaffold(
        //backgroundColor: Colors.grey[400],
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).pushNamed('/Add');
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Random Tasker'),
        ),
        drawer: NavBar(),
        body: ListView(
          children: taskList
              .map(
                (item) => StreamBuilder<Object>(
                    stream: null,
                    builder: (context, snapshot) {
                      return Dismissible(
                          //background: Container(
                          //  color: Colors.red,
                          //  padding: EdgeInsets.fromLTRB(3, 7, 3, 0),
                          //),
                          child: CustomCard(
                            data: item,
                            color: getPingColor(item.ping),
                          ),
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            _delete(context, item);
                            // setState(() {
                            //   taskList.remove(item);
                            // });
                            // Scaffold.of(context).showSnackBar(SnackBar(
                            //     duration: const Duration(seconds: 1),
                            //     content:
                            //         Text("Dismissed Task with a ${item.ping} ping")));
                          });
                    }),
              )
              .toList(),
          //useMagnifier: true,
          //physics: FixedExtentScrollPhysics(),
          //diameterRatio: 2,
          //offAxisFraction: 0.3,
          //magnification: 1.5,
          itemExtent: 135,
        ));
  }

  void _delete(BuildContext context, Task task) async {
    int result = await databaseHelper.deleteTask(task.id);
    setState(() {
      taskList.remove(task);
    });

    if (result != 0) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Task of ${task.ping} ping completed")));
    }
  }

  Color getPingColor(String ping) {
    switch (ping) {
      case 'high':
        return Colors.red;
        break;
      case 'medium':
        return Colors.yellow;
        break;

      case 'low':
        return Colors.green;
        break;

      default:
        return Colors.yellow;
    }
  }

  void refreshList() async {
    var newList = await databaseHelper.fetchTasks();
    setState(() {
      taskList = newList;
    });
  }
}

class CustomCard extends StatelessWidget {
  final Task data;
  final Color color;
  CustomCard({this.data, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.cyan,
            boxShadow: [BoxShadow(blurRadius: 9, color: Colors.cyan)],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          //trailing: Icon(Icons.delete, size: 30),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(3, 7, 3, 0),
            child: Text(data.task,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 3, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ping: ${data.ping}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text('${data.time}'))
              ],
            ),
          ),
          focusColor: Colors.black,
        ),
      ),
    );
  }
}
