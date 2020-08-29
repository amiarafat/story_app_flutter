
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  static final _dbName = 'story_database.db';
  static final _dbVersion = 1;

  //TABLE 1 -----  STORY
  static final _tableStory = 'story_table';
      static final storyId = 'story_id';
      static final storyName = 'story_name';
      static final storyDetails = 'story_details';


  //TABLE 2 -----  STORY REVIEW
  static final _tableReview = 'review_table';
      static final reviewId = 'review_id';
      static final reviewStoryId = 'review_story_id';
      static final reviewPoint = 'review_point';
      static final reviewDescription = 'review_description';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async{

    if(_database != null){
      return _database;
    }else{
      _database = await _initiateDatabase();
      return _database;
    }
  }

   _initiateDatabase() async{

    Directory directory = await getApplicationDocumentsDirectory();
    String _path = join(directory.path,_dbName);
    return await openDatabase(
      _path,
      version: _dbVersion,
      onCreate: onCreateTable,
    );
  }



  FutureOr<void> onCreateTable(Database db, int version) {
    //Table 1
    db.query(
        ''' 
        CREATE TABLE $_tableStory ( 
          $storyId INTEGER PRIMARY KEY,
          $storyName TEXT NOT NULL,
          $storyDetails TEXT NOT NULL 
          ) 
        '''
    );

    //Table 2
    db.query(
        ''' 
        CREATE TABLE $_tableReview ( 
          $reviewId INTEGER PRIMARY KEY,
          $reviewStoryId INTEGER,
          $reviewPoint TEXT NOT NULL,
          $reviewDescription TEXT NOT NULL 
          ) 
        '''
    );
  }

  Future<int> insert(String tableName, Map<String,dynamic> row) async{

    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String,dynamic>>> queryAll(String tableName) async{

    Database db = await instance.database;
    return await db.query(tableName);
  }


  Future updateStoryTable(String tableName, Map<String,dynamic> row) async {
    Database db = await instance.database;
    int _id = row[storyId];
    return await db.update(tableName, row ,where: '$storyId = ?',whereArgs: [_id]);
  }

  Future deleteRow(String tableName, int id) async {
    Database db = await instance.database;
    if(tableName == _tableStory) {
      return await db.delete(tableName, where: '$storyId =? ', whereArgs: [id]);
    }
    if(tableName == _tableReview) {
      return await db.delete(
          tableName, where: '$reviewId =? ', whereArgs: [id]);
    }
  }
}