import 'package:mongo_dart/mongo_dart.dart' show Db;

class DBConnection {
  static DBConnection _instance;

  Db _db;

  static DBConnection getInstance() {
    if (_instance == null) {
      _instance = DBConnection();
    }
    return _instance;
  }

  Future<Db> getConnection() async {
    if (_db == null) {
      try {
        _db = Db(_getConnectionString());
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

  _getConnectionString() {
    return "mongodb://mfilm:Proste123!@ds229438.mlab.com:29438/mfilm";
  }

  closeConnection() {
    _db.close();
  }
}