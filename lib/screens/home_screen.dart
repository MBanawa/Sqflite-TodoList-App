import 'package:flutter/material.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/service/todo_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TodoService _todoService;

  List<Todo> _todoList = List<Todo>();

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        //Navigate to todo create screen BUT also call build method to refresh todo list after
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())).then((value){
              setState(() {
                getAllTodos();
              });
            }),
            

        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('TodoList'),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:  EdgeInsets.only(top:8.0, left:8.0, right: 8.0),
            child: Card(
              elevation: 8,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_todoList[index].title ?? 'No Title'),
                  ],
                ),
                subtitle: Text(_todoList[index].category ?? 'No Category'),
                trailing: Text(_todoList[index].todoDate ?? 'No Date'),
              ),
            ),
          );
        },
      ),
    );
  }
}
