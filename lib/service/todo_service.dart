import 'package:todo_app/models/todo.dart';
import 'package:todo_app/repositories/repository.dart';

class TodoService {
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  //create todos
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  //read todos
  readTodos() async {
    return await _repository.readData('todos');
  }

//~~~~~ MY TRY ON MAKING MY OWN Update data from table
  updateTodosCategory(Todo todo) async{
    return await _repository.updateData('todos', todo.todoMap());
  }

  //read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName('todos', 'category', category);
  }
}
