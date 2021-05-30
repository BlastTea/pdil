part of 'services.dart';

class DbPra {
static DbPra _dbPra;
  static Database _database;
  FileHelper fileHelper = FileHelper();

  DbPra._createObject();

  factory DbPra() {
    if (_dbPra == null) {
      _dbPra = DbPra._createObject();
    }
    return _dbPra;
  }

  Future<Database> initDb() async {
    var databasePath = await getDatabasesPath();
    var path = databasePath + '/$tablePrabayar.db';

    try {
      await Directory(databasePath).create(recursive: true);
      await File(path).create(recursive: true);
    } catch (_) {}

    //create, read databases
    var todoDatabase = openDatabase('$tablePrabayar.db', version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePrabayar (
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
    var mapList = await db.query(tablePrabayar);
    return mapList;
  }

  Future<Pdil> selectWhere(String noMeter) async {
    Database db = await this.database;
    var mapList = await db.query(tablePrabayar, where: '$columnNoMeter=?', whereArgs: [noMeter]);

    Pdil pdil;
    if (mapList.length == 1) {
      var map = mapList[0];
      pdil = Pdil.fromMap(map);
    }
    return pdil;
  }

  Future<List<Pdil>> selectWhereAll(String search) async {
    Database db = await this.database;
    var mapList = await db.query(
      tablePrabayar,
      where: '''
      $columnIdPel LIKE ? AND (
        $columnIdPel LIKE ? OR
        $columnNoMeter LIKE ? OR
        $columnNama LIKE ? OR
        $columnAlamat LIKE ? OR
        $columnTarip LIKE ? OR
        $columnDaya LIKE ? OR
        $columnNoHp LIKE ? OR
        $columnNik LIKE ? OR
        $columnNpwp LIKE ? OR
        $columnEmail LIKE ? OR
        $columnCatatan LIKE ? 
      )
    ''',
      whereArgs: List.generate(12, (index) => search),
    );
    List<Pdil> pdils = [];
    mapList.forEach((map) {
      pdils.add(Pdil.fromMap(map));
    });
    return pdils;
  }

  Future<int> insert(Pdil object) async {
    Database db = await this.database;
    int count = await db.insert(tablePrabayar, object.toMap());
    return count;
  }

//update databases
  Future<int> update(Pdil object) async {
    Database db = await this.database;
    int count = await db.update(tablePrabayar, object.toMap(), where: '$columnNoMeter=?', whereArgs: [object.noMeter]);
    return count;
  }

//delete databases
  Future<int> delete(String noMeter) async {
    Database db = await this.database;
    int count = await db.delete(tablePrabayar, where: '$columnNoMeter=?', whereArgs: [noMeter]);
    return count;
  }

  Future<int> deleteAll() async {
    Database db = await this.database;
    int count = await db.delete(tablePrabayar);
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