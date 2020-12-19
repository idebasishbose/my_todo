import 'package:flutter/material.dart';

import 'bloc/todo_bloc.dart';
import 'data/todo.dart';
import 'main.dart';

class TodoScreen extends StatelessWidget {
  final Todo todo;
  final bool isNew;
  final txtName = TextEditingController();
  final txtDescription = TextEditingController();
  final txtCompleteBy = TextEditingController();
  final txtPriority = TextEditingController();

  final TodoBloc bloc;

  TodoScreen(this.todo, this.isNew) : bloc = TodoBloc();

  @override
  Widget build(BuildContext context) {
    final double padding = 10.0;
    txtName.text = todo.name;
    txtDescription.text = todo.description;
    txtCompleteBy.text = todo.completeBy;
    txtPriority.text = todo.priority.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: txtName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Headline',
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: txtDescription,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 500, //setting maximum length of the textfield
                  maxLengthEnforced:
                      true, //prevent the user from further typing  when maxLength is reached
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Description',
                    counterText: '',
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtCompleteBy,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Completed by'),
                )),
            Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: txtPriority,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Priority',
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(padding),
              child: MaterialButton(
                child: Text('Save'),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  if (txtName.text.isNotEmpty &&
                      txtDescription.text.isNotEmpty) {
                    save().then((_) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                        ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future save() async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.tryParse(txtPriority.text);
    if (isNew) {
      bloc.todoInsertSink.add(todo);
    } else {
      bloc.todoUpdateSink.add(todo);
    }
  }
}
