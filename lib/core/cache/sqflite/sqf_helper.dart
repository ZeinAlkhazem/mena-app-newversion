import 'package:mena/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

import '../../functions/main_funcs.dart';

Future<Database?> openMyDatabase() async {
  // Get a location using getDatabasesPath
  var databasesPath = await getDatabasesPath();
  String path = '$databasesPath/$databaseName';
  // Delete the database
  // await deleteDatabase(path);
  Database database = await openDatabase(path, version: databaseVersion,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE $databaseStoredJsonTableName (id INTEGER PRIMARY KEY, name	TEXT UNIQUE, json_val TEXT)');
  }).then((value) {
    logg('db created $value');
    return value;
  });

  return database;
}

Future<void> insertIntoMyDatabase({
  required String tableName,
  required String rawNameVal,
  required String jsonVal,
}) async {
  var databasesPath = await getDatabasesPath();
  String path = '$databasesPath/$databaseName';
  /// open database
  Database database = await openDatabase(
    path,
    version: databaseVersion,
  ).then((value) {
    logg('db opened $value');
    return value;
  });
  /// check if name exists update it
  ///
  List query = await database.query(tableName,
      columns: ['name'], where: '"name" = "$rawNameVal"');

  logg('list of search query:$query');
  ///
  ///
  if (query.isEmpty) {
    logg('didnt find this record... adding ...');

    /// start insert
    await database.rawInsert(
        'INSERT INTO "main"."$tableName"("name", "json_val")VALUES ("$rawNameVal", "$jsonVal");');
  } else {
    logg('record found ... updating ...');
    int count = await database.rawUpdate(
        'UPDATE $tableName SET name = "$rawNameVal", json_val = "$jsonVal" WHERE name = "$rawNameVal"');
    logg('updated: $count');
  }
}

Future<String> readJsonValFromMyDatabase({
  required String tableName,
  required String rawNameVal,
}) async {
  var databasesPath = await getDatabasesPath();
  String path = '$databasesPath/$databaseName';
  /// open database
  Database database = await openDatabase(
    path,
    version: databaseVersion,
  ).then((value) {
    logg('db opened $value');

    return value;
  });

  /// check if name exists update it
  ///
  ///
  List query = await database.query(tableName,
      columns: ['json_val'], where: '"name" = "$rawNameVal"');
  return query[0]['json_val'];
  ///
  ///
  ///
}
