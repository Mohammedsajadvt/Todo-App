import 'package:flutter/material.dart';
import 'package:todo/Service/todo_service.dart';
import 'package:todo/model/todo_model.dart';

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final TodoService _todoService = TodoService();

  List<TodoModel> _todos = [];

  Future<void> _loadTodos() async {
    _todos = await _todoService.getTodos();
    setState(() {});
  }

  @override
  void initState() {
    _loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF120369),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog();
          },
          child: const Icon(
            Icons.add,
          )),
      appBar: AppBar(
        title: const Text(
          "All Tasks",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0XFF120369),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: _todos.isEmpty
            ? const Center(
                child: Text(
                "No Task Added",
                style: TextStyle(color: Colors.white),
              ))
            : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return Card(
                    color: Color(0XFF120369),
                    elevation: 5.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      onTap: () {
                        _showEditingDialog(todo, index);
                      },
                      title: Text(
                        "${todo.title}",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${todo.description}",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Container(
                        width: 100,
                        child: Row(
                          children: [
                            Checkbox(
                                value: todo.activity,
                                activeColor: Colors.red,
                                onChanged: (value) {
                                  setState(() {
                                    todo.activity = value!;
                                    _todoService.updateTodo(index, todo);
                                    setState(() {});
                                  });
                                }),
                            IconButton(
                                onPressed: () async {
                                  await _todoService.deleteTodo(index);
                                  _loadTodos();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add New Task"),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(hintText: "description"),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(onPressed: () {}, child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    final newTodo = TodoModel(
                        title: _titleController.text,
                        description: _descController.text,
                        activity: false,
                        createdAt: DateTime.now());

                    await _todoService.addTodo(newTodo);
                    _titleController.clear();
                    _descController.clear();

                    Navigator.pop(context);

                    _loadTodos();
                  },
                  child: const Text("Add")),
            ],
          );
        });
  }

  Future<void> _showEditingDialog(TodoModel todo, int index) async {
    _titleController.text = todo.title;
    _descController.text = todo.description;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Task"),
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: "Title"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(hintText: "description"),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(onPressed: () {}, child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    todo.title = _titleController.text;
                    todo.description = _descController.text;
                    todo.createdAt = DateTime.now();

                    if (todo.activity == true) {
                      todo.activity = false;
                    }

                    await _todoService.updateTodo(index, todo);
                    _titleController.clear();
                    _descController.clear();

                    Navigator.pop(context);

                    _loadTodos();
                  },
                  child: const Text("Update")),
            ],
          );
        });
  }
}
