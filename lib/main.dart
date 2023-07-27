import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'ToDO App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.white),
            ),
            labelStyle: TextStyle(color: Colors.white),
          )
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = "";
  var favorites = <String>[];
  
  void addNewTask() {
    if (!favorites.contains(current.toString())) {
      favorites.add(current.toString());
    }
    
    notifyListeners();
  }

  void removeNewTask(String taskToRemove) {
    if (favorites.contains(taskToRemove)) {
      favorites.remove(taskToRemove);
    } 
    
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: Colors.redAccent,
      backgroundColor: Color.fromARGB(255, 255, 203, 203),
    );

    var appState = context.watch<MyAppState>();
    var taskList = appState.favorites;                 

    return Scaffold(
      body: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ToDo List APP by Mathieu",style: style,),
              ],
            ),
            Column(
              children: [
              ListTaskCard(taskList: taskList),
            ],),
            Column(
              children: [
              BigCard(),
              SizedBox(height: 30,),
              SizedBox(
                width: 100,
                height: 50,
                child:         
                  ElevatedButton(
                    onPressed: () {
                      appState.addNewTask();
                    }, 
                    child: Text("ADD"))
                  ),
            ],),
          ],
        ),
    );
  }
}

class ListTaskCard extends StatelessWidget {
  const ListTaskCard({
    super.key,
    required this.taskList,
  });

  final List<String> taskList;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView.separated(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    padding: const EdgeInsets.all(8),
    itemCount: taskList.length,
    itemBuilder: (BuildContext context, int index) {
      return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(taskList[index]),
            ElevatedButton(
              onPressed: () {
                appState.removeNewTask(taskList[index]);
              }, 
              child: Icon(Icons.clear)),
          ]
        )
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
  }
}



class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
     final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    var appState = context.watch<MyAppState>();

    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
        onChanged: (value) {
            appState.current = value; 
        },
        style:style,
        decoration: InputDecoration(
          labelText: 'Entrez votre Tâche',
          ),
          )
        ),
      );
  }
}

