import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var path = join(await getDatabasesPath(), 'vhm_crud');
    //await deleteDatabase(path);
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sqlNewMembers =
        "CREATE TABLE newMembers (id INTEGER PRIMARY KEY, memberLastName TEXT, memberFirstName TEXT, memberPhone TEXT, memberDateOfEntry TEXT, memberInvitedBy TEXT, memberGender TEXT, churchId INTEGER, memberTypeId INTEGER);";
    await database.execute(sqlNewMembers);

    String sqlMembers =
        "CREATE TABLE Members (memberId INTEGER PRIMARY KEY, memberLastName TEXT, memberFirstName TEXT, memberFullName TEXT, memberPhone TEXT, memberStatus TEXT, flag INTEGER);";
    await database.execute(sqlMembers);

    String sqlLeamans =
        "CREATE TABLE Leamans (id INTEGER PRIMARY KEY, leamanLastName TEXT, leamanFirstName TEXT, leamanPhone TEXT, leamanDateOfEntry TEXT, leamanGender TEXT, leamanStatus TEXT, leamanChurch TEXT, leamanChurchInfo TEXT, leamanInvited TEXT);";
    await database.execute(sqlLeamans);
  }
}
