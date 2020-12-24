import 'package:flutter/material.dart';

import '../bloc/todo_bloc.dart';
import '../data/todo.dart';
import 'home_screen.dart';

class TodoScreen extends StatefulWidget {
  final Todo todo;
  final bool isNew;
  final TodoBloc bloc;

  TodoScreen(this.todo, this.isNew) : bloc = TodoBloc();

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController _txtNameTEController = TextEditingController();

  TextEditingController _txtDescriptionTEController = TextEditingController();

  TextEditingController _txtCompleteByTEController = TextEditingController();

  TextEditingController _txtPriorityTEController = TextEditingController();

  @override
  void initState() {
    _txtNameTEController.text = "";
    _txtDescriptionTEController.text = "";
    _txtCompleteByTEController.text = "";
    _txtPriorityTEController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    _txtNameTEController.dispose();
    _txtDescriptionTEController.dispose();
    _txtCompleteByTEController.dispose();
    _txtPriorityTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = 10.0;
    _txtNameTEController.text = widget.todo.name;
    _txtDescriptionTEController.text = widget.todo.description;
    _txtCompleteByTEController.text = widget.todo.completeBy;
    _txtPriorityTEController.text = widget.todo.priority.toString();
    return SafeArea(
      child: Scaffold(
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
                  controller: _txtNameTEController,
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
                    controller: _txtDescriptionTEController,
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
                    controller: _txtCompleteByTEController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Completed by'),
                  )),
              Padding(
                  padding: EdgeInsets.all(padding),
                  child: TextField(
                    controller: _txtPriorityTEController,
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
                    if (_txtNameTEController.text.isNotEmpty &&
                        _txtDescriptionTEController.text.isNotEmpty) {
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
      ),
    );
  }

  Future save() async {
    widget.todo.name = _txtNameTEController.text;
    widget.todo.description = _txtDescriptionTEController.text;
    widget.todo.completeBy = _txtCompleteByTEController.text;
    widget.todo.priority = int.tryParse(_txtPriorityTEController.text);
    if (widget.isNew) {
      widget.bloc.todoInsertSink.add(widget.todo);
    } else {
      widget.bloc.todoUpdateSink.add(widget.todo);
    }
  }
}
