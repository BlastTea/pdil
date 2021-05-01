part of 'services.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  FileHelper fileHelper = FileHelper();

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    var databasePath = await getDatabasesPath();
    var path = databasePath + '/pdil.db';

    try {
      await Directory(databasePath).create(recursive: true);
      await File(path).create(recursive: true);
    } catch (_) {}

    //create, read databases
    var todoDatabase = openDatabase('pdil.db', version: 2, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePdil (
        $columnIdPel TEXT PRIMARY KEY, 
        $columnNama TEXT, 
        $columnAlamat TEXT, 
        $columnTarip TEXT, 
        $columnDaya TEXT, 
        $columnNoHp TEXT, 
        $columnNik TEXT, 
        $columnNpwp TEXT,
        $columnCatatan TEXT,
        $columnIsKoreksi INTEGER,
        $columnTanggalBaca TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query(tablePdil);
    return mapList;
  }

  Future<Pdil> selectWhere(String idPel) async {
    Database db = await this.database;
    var mapList = await db.query(tablePdil, where: '$columnIdPel=?', whereArgs: [idPel]);

    Pdil pdil;
    if (mapList.length == 1) {
      var map = mapList[0];
      pdil = Pdil.fromMap(map);
    }
    return pdil;
  }

//create databases
  Future<int> insert(Pdil object) async {
    Database db = await this.database;
    int count = await db.insert(tablePdil, object.toMap());
    return count;
  }

//update databases
  Future<int> update(Pdil object) async {
    Database db = await this.database;
    int count = await db.update(tablePdil, object.toMap(), where: '$columnIdPel=?', whereArgs: [object.idPel]);
    return count;
  }

//delete databases
  Future<int> delete(String idPel) async {
    Database db = await this.database;
    int count = await db.delete(tablePdil, where: '$columnIdPel=?', whereArgs: [idPel]);
    return count;
  }

  Future<int> deleteAll() async {
    Database db = await this.database;
    int count = await db.delete(tablePdil);
    return count;
  }

  Future<List<Pdil>> getPdilList() async {
    var pdilMapList = await select();
    int count = pdilMapList.length;
    List<Pdil> pdilList = [];
    for (int i = 0; i < count; i++) {
      pdilList.add(Pdil.fromMap(pdilMapList[i]));
    }
    return pdilList;
  }
}
