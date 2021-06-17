part of 'services.dart';

class DbPasca {
  static DbPasca _dbPasca;
  static Database _database;
  FileHelper fileHelper = FileHelper();

  DbPasca._createObject();

  factory DbPasca() {
    if (_dbPasca == null) {
      _dbPasca = DbPasca._createObject();
    }
    return _dbPasca;
  }

  Future<Database> initDb() async {
    var databasePath = await getDatabasesPath();
    var path = databasePath + '/pdilPasca.db';

    try {
      await Directory(databasePath).create(recursive: true);
      await File(path).create(recursive: true);
    } catch (_) {}

    //create, read databases
    var todoDatabase = openDatabase('pdilPasca.db', version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePascabayar (
        $columnIdPel TEXT PRIMARY KEY,
        $columnNoMeter TEXT,
        $columnNama TEXT, 
        $columnAlamat TEXT, 
        $columnTarip TEXT, 
        $columnDaya TEXT, 
        $columnNoHp TEXT, 
        $columnNik TEXT, 
        $columnNpwp TEXT,
        $columnEmail TEXT,
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
    var mapList = await db.query(tablePascabayar);
    return mapList;
  }

  Future<Pdil> selectWhere(String idPel) async {
    Database db = await this.database;
    var mapList = await db.query(tablePascabayar, where: '$columnIdPel=?', whereArgs: [idPel]);

    Pdil pdil;
    if (mapList.length == 1) {
      var map = mapList[0];
      pdil = Pdil.fromMap(map);
    }
    return pdil;
  }

  Future<List<String>> selectWhereAll({@required String query, @required String column}) async {
    Database db = await this.database;
    var mapList = await db.query(
      tablePascabayar,
      distinct: true,
      columns: [column],
      where: '$column LIKE ?',
      whereArgs: ['%$query%'],
    );
    List<String> strings = [];
    mapList.forEach((map) {
      strings.add(map[column]);
    });
    return strings;
  }

  Future<int> insert(Pdil object) async {
    Database db = await this.database;
    int count = await db.insert(tablePascabayar, object.toMap());
    return count;
  }

//update databases
  Future<int> update(Pdil object) async {
    Database db = await this.database;
    int count = await db.update(tablePascabayar, object.toMap(), where: '$columnIdPel=?', whereArgs: [object.idPel]);
    return count;
  }

//delete databases
  Future<int> delete(String idPel) async {
    Database db = await this.database;
    int count = await db.delete(tablePascabayar, where: '$columnIdPel=?', whereArgs: [idPel]);
    return count;
  }

  Future<int> deleteAll() async {
    Database db = await this.database;
    int count = await db.delete(tablePascabayar);
    return count;
  }

  Future<List<Pdil>> getPdilList({String query}) async {
    if (query != null) {
      Database db = await this.database;
      var mapList = await db.query(
        tablePascabayar,
        where: '''
          $columnIdPel LIKE ? OR
          $columnNama LIKE ? OR
          $columnAlamat LIKE ? OR
          $columnTarip LIKE ? OR
          $columnDaya LIKE ? OR
          $columnNoHp LIKE ? OR
          $columnNik LIKE ? OR
          $columnNpwp LIKE ? OR
          $columnEmail LIKE ? OR
          $columnCatatan LIKE ?
        ''',
        whereArgs: List.generate(10, (index) => query),
        distinct: true,
      );
      
      List<Pdil> listPdils = [];
      mapList.forEach((mapPdil) { 
        listPdils.add(Pdil.fromMap(mapPdil));
      });
      return listPdils;
    }
    
    var pdilMapList = await select();
    List<Pdil> pdilList = [];
    for (int i = 0; i < pdilMapList.length; i++) {
      pdilList.add(Pdil.fromMap(pdilMapList[i]));
    }
    return pdilList;
  }
}
