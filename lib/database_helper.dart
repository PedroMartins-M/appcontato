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
      version: 2, // Aumentado para 2 para executar o onUpgrade se necessário
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contatos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            telefone TEXT,
            favorito INTEGER,
            categoria TEXT
          )
        ''');
      },
      onUpgrade: (db, versaoAntiga, versaoNova) {
        if (versaoAntiga < 2) {
          db.execute('ALTER TABLE contatos ADD COLUMN categoria TEXT');
        }
      },
    );
  }

  // Inserir contato incluindo a CATEGORIA
  static Future<void> inserirContato(String nome, String telefone, String categoria) async {
    final db = await DatabaseHelper.database;
    await db.insert('contatos', {
      'nome': nome,
      'telefone': telefone,
      'favorito': 0, // 0 = Falso, 1 = Verdadeiro
      'categoria': categoria,
    });
  }

  // Listar contatos
  static Future<List<Map<String, dynamic>>> obterContatos({
    String? filtro,
  }) async {
    final db = await database;

    if (filtro == 'favoritos') {
      return db.query(
        'contatos',
        where: 'favorito = ?',
        whereArgs: [1],
        orderBy: 'nome ASC',
      );
    } else if (filtro == 'normais') {
      return db.query(
        'contatos',
        where: 'favorito = ?',
        whereArgs: [0],
        orderBy: 'nome ASC',
      );
    }
    return db.query('contatos', orderBy: 'nome ASC');
  }

  // Alternar Favorito
  static Future<int> alternarFavorito(int id, bool novoStatus) async {
    final db = await database;
    return await db.update(
      'contatos',
      {'favorito': novoStatus ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Excluir contato
  static Future<void> excluirContato(int id) async {
    final db = await DatabaseHelper.database;
    await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}