import 'package:Assistant/pages/AddTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Assistant!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
  List tasks = <String>[
    "OwO",
    "UwU",
    "xwx",
    "xwx",
    "xwx",
    "xwx",
    "xwx",
    "xwx",
    "xwx",
    "xwx",
    "xwx",
    "xwx",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Random Tasker'),
        ),
        drawer: NavBar(),
        body: ListWheelScrollView(
          children: tasks.map((data) => CustomCard(content: data)).toList(),
          useMagnifier: true,
          offAxisFraction: 0.5,
          magnification: 1.5,
          itemExtent: 91,
        ));
  }
}

class CustomCard extends StatelessWidget {
  final String content;
  final List colors = [Colors.red, Colors.green, Colors.yellow];
  final Random random = new Random();
  CustomCard({this.content});
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors[random.nextInt(3)],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(content,
              style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          SizedBox(
            height: 6,
          ),
          Text("- Sam",
              style: TextStyle(fontSize: 14, color: Colors.grey[800])),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Sam'),
            accountEmail: Text('samjerub@gmail.com'),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/empty_avatar.png')),
          ),
          ListTile(
            title: Text("Random Task"),
            leading: Icon(Icons.account_balance_wallet),
          ),
          ListTile(
            title: Text("Add Task"),
            leading: Icon(Icons.add_circle),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Add');
            },
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            title: Text("Exit"),
            leading: Icon(Icons.close),
            onTap: () => SystemNavigator.pop(),
          ),
        ]),
      ),
    );
  }
}
