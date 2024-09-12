import 'package:mongo_dart/mongo_dart.dart';
import 'package:dotenv/dotenv.dart';

abstract class DatabaseService {
  Future<void> connect();
  Future<Map<String, dynamic>> get(String collection, String id);
  Future<List<Map<String, dynamic>>> getAll(String collection);
  Future<Map<String, dynamic>> create(
      String collection, Map<String, dynamic> data);
  Future<Map<String, dynamic>> update(
      String collection, String id, Map<String, dynamic> data);
  Future<void> delete(String collection, String id);
  Future<Map<String, dynamic>> getWhere(
      String collection, String field, String value);
}

class DatabaseServiceImpl implements DatabaseService {
  Db? _db;
  late DotEnv env;

  DatabaseServiceImpl() {
    env = DotEnv(includePlatformEnvironment: true)..load();
  }

  @override
  Future<void> connect() async {
    if (_db == null || !_db!.isConnected) {
      final connectionString = env['MONGODB_CONNECTION_STRING'];
      if (connectionString == null) {
        throw Exception('MONGODB_CONNECTION_STRING not found in .env file');
      }
      _db = await Db.create(connectionString);
      await _db!.open();
    }
  }

  Future<void> _ensureConnected() async {
    if (_db == null || !_db!.isConnected) {
      await connect();
    }
  }

  @override
  Future<Map<String, dynamic>> get(String collection, String id) async {
    await _ensureConnected();
    final result = await _db!
        .collection(collection)
        .findOne(where.id(ObjectId.fromHexString(id)));
    return result ?? {};
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    await _ensureConnected();
    final result = await _db!.collection(collection).find().toList();
    return result;
  }

  @override
  Future<Map<String, dynamic>> create(
      String collection, Map<String, dynamic> data) async {
    await _ensureConnected();
    final result = await _db!.collection(collection).insertOne(data);
    return result.document ?? {};
  }

  @override
  Future<Map<String, dynamic>> update(
      String collection, String id, Map<String, dynamic> data) async {
    await _ensureConnected();
    final result = await _db!.collection(collection).findAndModify(
          query: where.id(ObjectId.fromHexString(id)),
          update: data,
          returnNew: true,
        );
    return result ?? {};
  }

  @override
  Future<void> delete(String collection, String id) async {
    await _ensureConnected();
    await _db!
        .collection(collection)
        .remove(where.id(ObjectId.fromHexString(id)));
  }

  // Generic getWhere
  @override
  Future<Map<String, dynamic>> getWhere(
      String collection, String field, String value) async {
    await _ensureConnected();
    final result =
        await _db!.collection(collection).findOne(where.eq(field, value));
    return result ?? {};
  }
}
