// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CartDao? _cartDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CartItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `image` TEXT, `description` TEXT, `currency` TEXT, `price` TEXT, `quantity` INTEGER, `productId` TEXT, `subProductId` TEXT, `merchantId` INTEGER, `baseMarkup` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CartDao get cartDao {
    return _cartDaoInstance ??= _$CartDao(database, changeListener);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _cartItemInsertionAdapter = InsertionAdapter(
            database,
            'CartItem',
            (CartItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'image': item.image,
                  'description': item.description,
                  'currency': item.currency,
                  'price': item.price,
                  'quantity': item.quantity,
                  'productId': item.productId,
                  'subProductId': item.subProductId,
                  'merchantId': item.merchantId,
                  // 'createdAt': item.createdAt,
                  'baseMarkup': item.baseMarkup
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CartItem> _cartItemInsertionAdapter;

  @override
  Stream<List<CartItem>> listenToItemUpdates() {
    return _queryAdapter.queryListStream('SELECT * FROM CartItem',
        mapper: (Map<String, Object?> row) => CartItem(
              id: row['id'] as int?,
              name: row['name'] as String?,
              image: row['image'] as String?,
              description: row['description'] as String?,
              currency: row['currency'] as String?,
              price: row['price'] as String?,
              quantity: row['quantity'] as int?,
              productId: row['productId'] as String?,
              subProductId: row['subProductId'] as String?,
              merchantId: row['merchantId'] as int?,
              baseMarkup: row['baseMarkup'] as String?,
              // createdAt: row['createdAt'] as String?
            ),
        queryableName: 'CartItem',
        isView: false);
  }

  @override
  Future<List<CartItem>> getAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM CartItem',
        mapper: (Map<String, Object?> row) => CartItem(
              id: row['id'] as int?,
              name: row['name'] as String?,
              image: row['image'] as String?,
              description: row['description'] as String?,
              currency: row['currency'] as String?,
              price: row['price'] as String?,
              quantity: row['quantity'] as int?,
              productId: row['productId'] as String?,
              subProductId: row['subProductId'] as String?,
              merchantId: row['merchantId'] as int?,
              baseMarkup: row['baseMarkup'] as String?,
              // createdAt: row['createdAt'] as String?
            ));
  }

  @override
  Future<CartItem?> getCartItem(int productId) async {
    return _queryAdapter.query('SELECT * FROM CartItem WHERE productId = ?1',
        mapper: (Map<String, Object?> row) => CartItem(
              id: row['id'] as int?,
              name: row['name'] as String?,
              image: row['image'] as String?,
              description: row['description'] as String?,
              currency: row['currency'] as String?,
              price: row['price'] as String?,
              quantity: row['quantity'] as int?,
              productId: row['productId'] as String?,
              subProductId: row['subProductId'] as String?,
              merchantId: row['merchantId'] as int?,
              baseMarkup: row['baseMarkup'] as String?,
              // createdAt: row['createdAt'] as String?
            ),
        arguments: [productId]);
  }

  @override
  Future<CartItem?> getCartItemBySubProductId(String subProductId) async {
    return _queryAdapter.query('SELECT * FROM CartItem WHERE subProductId = ?1',
        mapper: (Map<String, Object?> row) => CartItem(
              id: row['id'] as int?,
              name: row['name'] as String?,
              image: row['image'] as String?,
              description: row['description'] as String?,
              currency: row['currency'] as String?,
              price: row['price'] as String?,
              quantity: row['quantity'] as int?,
              productId: row['productId'] as String?,
              subProductId: row['subProductId'] as String?,
              merchantId: row['merchantId'] as int?,
              baseMarkup: row['baseMarkup'] as String?,
              //  createdAt: row['createdAt'] as String?
            ),
        arguments: [subProductId]);
  }

  @override
  Future<void> deleteItem(String subProductId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM CartItem WHERE subProductId = ?1',
        arguments: [subProductId]);
  }

  @override
  Future<void> nuke() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CartItem');
  }

  @override
  Future<void> insert(CartItem cartItem) async {
    await _cartItemInsertionAdapter.insert(
        cartItem, OnConflictStrategy.replace);
  }
}
