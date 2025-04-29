import 'package:slp_notebook/database/database_service.dart';
import 'package:slp_notebook/models/client.dart';
import 'package:slp_notebook/models/goal.dart';
import 'package:slp_notebook/models/note.dart';
import 'package:slp_notebook/models/session.dart';
import 'package:sqflite/sqflite.dart';

//amazing yt video for this stuff: https://www.youtube.com/watch?v=9kbt4SBKhm0&t=247s

class SlpNotebookDb {
  final clientTableName = 'client';
  final sessionTableName = 'session';
  final noteTableName = 'note';
  final goalTableName = 'goal';

  //create all tables
  Future<void> createTables(Database database) async {
    await createClientTable(database);
    await createSessionTable(database);
    await createNoteTable(database);
    await createGoalTable(database);
  }
  
  //
  // Client Table
  //

  Future<void> createClientTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $clientTableName (
      "id" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      "description" TEXT NOT NULL,
      "birthday" INTEGER NOT NULL,
      PRIMARY KEY ("id" AUTOINCREMENT)
    );""");
  }

  Future<int> insertClient({required String name, required String description, required int birthday}) async{
    final database = await DatabaseService().database;
    return await database.rawInsert('''INSERT INTO $clientTableName (name,description,birthday) VALUES(?,?,?)''',[name,description, birthday]);
  }

  Future<List<Client>> getAllClients() async {
    final database = await DatabaseService().database;
    final clients = await database.rawQuery('''SELECT * FROM $clientTableName''');
    return clients.map((client) => Client.fromSqfliteDatabase(client)).toList();
  }

  Future<Client> getClientById(int id) async {
    final database = await DatabaseService().database;
    final client = await database.rawQuery('''SELECT * FROM $clientTableName WHERE id = ?''',[id]);
    return Client.fromSqfliteDatabase(client.first);
  }

  Future<int> _deleteClientRecordById(int id) async {
    final database = await DatabaseService().database;
    return await database.rawDelete('''DELETE FROM $clientTableName WHERE id = ?''',[id]);
  }

  Future<int> deleteClientById(int id) async {
    await deleteGoalsByClientId(id);
    await deleteSessionsByClientId(id);
    return await _deleteClientRecordById(id);
  }
  
  //
  // Session Table
  //

  Future<void> createSessionTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $sessionTableName (
      "id" INTEGER NOT NULL,
      "clientId" INTEGER NOT NULL,
      "createDate" INTEGER NOT NULL,
      PRIMARY KEY ("id" AUTOINCREMENT),
      FOREIGN KEY (clientId) REFERENCES $clientTableName(id)
    );""");
  }

  Future<int> insertSession({required int clientId, required int createDate}) async{
    final database = await DatabaseService().database;
    return await database.rawInsert('''INSERT INTO $sessionTableName (clientId,createDate) VALUES(?,?)''',[clientId,createDate]);
  }

  Future<List<Session>> getSessionsByClientId(int clientId) async {
    final database = await DatabaseService().database;
    final sessions = await database.rawQuery('''SELECT * FROM $sessionTableName WHERE clientId = ?''',[clientId]);
    return sessions.map((session) => Session.fromSqfliteDatabase(session)).toList();
  }

  Future<Session> getSessionById(int id) async {
    final database = await DatabaseService().database;
    final sessions = await database.rawQuery('''SELECT * FROM $sessionTableName WHERE id = ?''',[id]);
    return Session.fromSqfliteDatabase(sessions.first);
  }

  Future<int> _deleteSessionRecordById(int id) async {
    final database = await DatabaseService().database;
    return await database.rawDelete('''DELETE FROM $sessionTableName WHERE id = ?''',[id]);
  }

  Future<int> deleteSessionById(int id) async {
    await deleteNotesBySessionId(id);
    return await _deleteSessionRecordById(id);
  }

  Future<int> deleteSessionsByClientId(int id) async {
    var sessions = await getSessionsByClientId(id);
    for(var session in sessions){
      deleteNotesBySessionId(session.id);
      _deleteSessionRecordById(session.id);
    }
    return 0;
  }

  
  //
  // Note Table
  //

  Future<void> createNoteTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $noteTableName (
      "id" INTEGER NOT NULL,
      "sessionId" INTEGER NOT NULL,
      "goalId" INTEGER NOT NULL,
      "bodyText" TEXT NULL,
      "useScore" INTEGER NOT NULL,
      "scoreNumerator" INTEGER NOT NULL,
      "scoreDenominator" INTEGER NOT NULL,
      PRIMARY KEY ("id" AUTOINCREMENT),
      FOREIGN KEY (sessionId) REFERENCES $sessionTableName(id)
    );""");
  }

  Future<int> insertNote({required int sessionId, required String bodyText, int scoreNumerator = 0, int scoreDenominator = 0, int goalId = 0}) async{
    int useScoreAsInt = 0;
    if(scoreDenominator == 0){
      useScoreAsInt = 1;
    }
    final database = await DatabaseService().database;
    return await database.rawInsert('''INSERT INTO $noteTableName (sessionId,goalId,bodyText,useScore,scoreNumerator,scoreDenominator) VALUES(?,?,?,?,?,?)''',[sessionId,goalId,bodyText,useScoreAsInt,scoreNumerator,scoreDenominator]);
  }

  Future<int> editNote({required int noteId, required String bodyText, int scoreNumerator = 0, int scoreDenominator = 0, int goalId = 0}) async{
    int useScoreAsInt = 0;
    if(scoreDenominator == 0){
      useScoreAsInt = 1;
    }
    final database = await DatabaseService().database;
    return await database.rawInsert('''UPDATE $noteTableName SET goalId = ?, bodyText = ?, useScore = ?, scoreNumerator = ?, scoreDenominator = ? WHERE Id = ?''',[goalId,bodyText,useScoreAsInt,scoreNumerator,scoreDenominator, noteId]);
  }

  Future<List<Note>> getNotesBySessionId({required int sessionId}) async {
    final database = await DatabaseService().database;
    final notes = await database.rawQuery('''SELECT * FROM $noteTableName WHERE sessionId = ?''',[sessionId]);
    return notes.map((note) => Note.fromSqfliteDatabase(note)).toList();
  }

  Future<int> deleteNotesBySessionId(int sessionId) async {
    final database = await DatabaseService().database;
    return await database.rawDelete('''DELETE FROM $noteTableName WHERE sessionId = ?''',[sessionId]);
  }

  //
  // Goal Table
  //
  
  
  Future<void> createGoalTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $goalTableName (
      "id" INTEGER NOT NULL,
      "clientId" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      PRIMARY KEY ("id" AUTOINCREMENT),
      FOREIGN KEY (clientId) REFERENCES $clientTableName(id)
    );""");
  }

  Future<int> insertGoal({required int clientId, required String name,}) async{
    final database = await DatabaseService().database;
    return await database.rawInsert('''INSERT INTO $goalTableName (clientId,name) VALUES(?,?)''',[clientId,name]);
  }

  Future<List<Goal>> getGoalsByClientId({required int clientId}) async {
    final database = await DatabaseService().database;
    final goals = await database.rawQuery('''SELECT * FROM $goalTableName WHERE clientId = ?''',[clientId]);
    return goals.map((goal) => Goal.fromSqfliteDatabase(goal)).toList();
  }

  Future<Goal> getGoalById({required int goalId}) async {
    final database = await DatabaseService().database;
    final goals = await database.rawQuery('''SELECT * FROM $goalTableName WHERE Id = ?''',[goalId]);
    return Goal.fromSqfliteDatabase(goals.first);
  }

  Future<int> deleteGoalsByClientId(int clientId) async {
    final database = await DatabaseService().database;
    return await database.rawDelete('''DELETE FROM $goalTableName WHERE clientId = ?''',[clientId]);
  }
  
  //
  // Multi-Table
  //

  Future<int> deleteClientAndSessions(int clientId) async {
    await deleteSessionsByClientId(clientId);
    return await deleteClientById(clientId);
  }
}