import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager/models/task_model.dart';

class QuantumRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quantum_tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            state TEXT,
            impactScore REAL,
            energyRequirement REAL,
            createdAt TEXT,
            deadline TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTask(QuantumTask task) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'state': task.state.name,
        'impactScore': task.impactScore,
        'energyRequirement': task.energyRequirement,
        'createdAt': task.createdAt.toIso8601String(),
        'deadline': task.deadline?.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QuantumTask>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return QuantumTask(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        state: QuantumState.values.firstWhere((e) => e.name == maps[i]['state']),
        impactScore: maps[i]['impactScore'],
        energyRequirement: maps[i]['energyRequirement'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
        deadline: maps[i]['deadline'] != null ? DateTime.parse(maps[i]['deadline']) : null,
      );
    });
  }

  Future<void> updateTask(QuantumTask task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'state': task.state.name,
        'impactScore': task.impactScore,
        'energyRequirement': task.energyRequirement,
        'deadline': task.deadline?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
