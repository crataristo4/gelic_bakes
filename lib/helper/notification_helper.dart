import 'package:gelic_bakes/models/notification_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableNotification = 'notification';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'notifDateTime';
final String columnPending = 'isPending';

class NotificationHelper {
  static Database? _database;
  static NotificationHelper? _alarmHelper;

  NotificationHelper._createInstance();

  factory NotificationHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = NotificationHelper._createInstance();
    }
    return _alarmHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "notification.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableNotification ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDateTime text not null,
          $columnPending integer)
        ''');
      },
    );
    return database;
  }

  void insertNotification(NotificationInfo notificationInfo) async {
    var db = await this.database;
    await db.insert(tableNotification, notificationInfo.toMap());
    // print('result : $result');
  }

/*Future<List<NotificationInfo>> getNotificationList() async {
    List<NotificationInfo> _notificationList = [];

    var db = await this.database;
    var result = await db.query(tableNotification);
    result.forEach((element) {
      var notificationInfo = NotificationInfo.fromMap(element);
      _notificationList.add(notificationInfo);
    });

    return _notificationList;
  }*/

/*  Future<int> delete(int id) async {
    var db = await this.database;
    return await db
        .delete(tableNotification, where: '$columnId = ?', whereArgs: [id]);
  }*/
}
