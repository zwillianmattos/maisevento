import 'package:mongo_dart/mongo_dart.dart';
import 'package:maisevento/models/user.dart';
import 'package:maisevento/models/event.dart';

class DatabaseService {
  static Db? _db;
  static const String _connectionString =
      'mongodb+srv://teste:AVBFKv45F9LmXLR@cluster0.n3j8j.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

  Future<Db> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Db> _initDatabase() async {
    final db = await Db.create(_connectionString);
    await db.open();
    return db;
  }

  // User operations
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final userCollection = db.collection('users');
    final userMap = await userCollection.findOne(where.eq('email', email));
    return userMap != null ? User.fromJson(userMap) : null;
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    final userCollection = db.collection('users');
    await userCollection.insert(user.toJson());
  }

  // Event operations
  Future<void> insertEvent(Event event) async {
    final db = await database;
    final eventCollection = db.collection('events');
    await eventCollection.insert(event.toJson());
  }

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    final eventCollection = db.collection('events');
    final eventMaps = await eventCollection.find().toList();
    return eventMaps.map((eventMap) => Event.fromJson(eventMap)).toList();
  }

  Future<Event?> getEventById(ObjectId id) async {
    final db = await database;
    final eventCollection = db.collection('events');
    final eventMap = await eventCollection.findOne(where.id(id));
    return eventMap != null ? Event.fromJson(eventMap) : null;
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    final eventCollection = db.collection('events');
    await eventCollection.update(
      where.id(event.id!),
      event.toJson(),
    );
  }

  Future<void> deleteEvent(ObjectId id) async {
    final db = await database;
    final eventCollection = db.collection('events');
    await eventCollection.remove(where.id(id));
  }
}
