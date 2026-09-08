import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'contatos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contatos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            telefone TEXT,
            favorito INTEGER
          )
        ''');
      },
    );
  }

  // Inserir contato
  static Future<int> inserirContato(Map<String, dynamic> contato) async {
    final db = await database;
    return await db.insert('contatos', contato);
  }

  // Listar contatos
  static Future<List<Map<String, dynamic>>> obterContatos() async {
    final db = await database;
    return await db.query('contatos', orderBy: 'nome ASC');
  }

  // Alternar Favorito (0 = false, 1 = true)
  static Future<int> alternarFavorito(int id, bool novoStatus) async {
    final db = await database;
    return await db.update(
      'contatos',
      {'favorito': novoStatus ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> excluirContato(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
