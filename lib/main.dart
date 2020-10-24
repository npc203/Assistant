import 'package:Assistant/pages/AddTask.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
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
        '/Add': (context) => AddTask(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> taskList;
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = List<Task>();
      updateListView();
    }
    return Scaffold(
        //backgroundColor: Colors.grey[400],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
                (item) => Dismissible(

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

  getTasksList() async {
    var taskMapList = await databaseHelper.getTasksMapList();
    List<Task> tasks = taskMapList.map((e) => Task.fromMap(e)).toList();
    return tasks;
  }

  void updateListView() async {
    getTasksList().then((newtaskList) {
      print("DATA ${newtaskList[0].id}");
      setState(() {
        taskList = newtaskList;
      });
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
            child: Text("OWO${data.task}",
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
