import 'package:netfilm/util/constants.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db;

import 'constants.dart';

class DBConnection {
  static DBConnection _instance;

  static DBConnection getInstance() {
    if (_instance == null) {
      _instance = DBConnection();
    }
    return _instance;
  }

  Future<Db> getConnection() async {
    Db _db;

    if (_db == null) {
      try {
        _db = Db(MONGODB_KEY);
      } catch (e) {
        print(e);
      }
    }
    try {
      await _db.open();
    } catch (e) {
      print(e);
    }

    return _db;
  }

  closeConnection(Db _db) {
    _db.close();
  }
}
