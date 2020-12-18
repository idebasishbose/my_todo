import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:todo_sembast/data/todo.dart';

class TodoDb {
  //this needs to be a singleton
  static final TodoDb _singleton = TodoDb._internal();

  //private internal constructor
  TodoDb._internal();

  factory TodoDb() {
    return _singleton;
  }

  //DatabaseFactory allows to open a db
  DatabaseFactory dbFactory = databaseFactoryIo;

  //specifying store/folders for our r/w operations.
  final store = intMapStoreFactory.store('todos');

  //opening the db
  Database _database;

  //getter to check in _database is set or not.
  Future<Database> get database async {
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }
    return _database;
  }

//opens the sembast db
  Future _openDb() async {
    //using path_provider library, otherwise it would have been platform specific implementation!
    final docsPath = await getApplicationDocumentsDirectory();

    //joining system path and name of the db in it.
    final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);

    return db;
  }

  //insert operation
  Future insertTodo(Todo todo) async {
    await store.add(_database, todo.toMap());
  }

  //update operation
  Future updateTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database, todo.toMap(), finder: finder);
  }

  //delete single item operation
  Future deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database, finder: finder);
  }

  //clear all records from the store
  Future deleteAll() async {
    await store.delete(_database);
  }

  //get Todos
  Future<List<Todo>> getTodos() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('priority'),
      SortOrder('id'),
    ]);
    final todoSnapshot = await store.find(_database, finder: finder);
    return todoSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }
}
