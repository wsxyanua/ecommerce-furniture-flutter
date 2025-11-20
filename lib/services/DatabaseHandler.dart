
import 'package:furniture_app_project/models/history_search_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../models/user_model.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'furniture.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Cart("
              "idCart INTEGER PRIMARY KEY AUTOINCREMENT,"
              "nameProduct TEXT NOT NULL,"
              "color TEXT NOT NULL,"
              "imgProduct TEXT NOT NULL,"
              "idProduct TEXT NOT NULL,"
              "quantity INTEGER NOT NULL, "
              "price REAL NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE Favorite("
              "idFavorite INTEGER PRIMARY KEY AUTOINCREMENT,"
              "nameProduct TEXT NOT NULL,"
              "imgProduct TEXT NOT NULL,"
              "idProduct TEXT NOT NULL,"
              "price REAL NOT NULL)",
        );
        await database.execute("CREATE TABLE UserSQ("
            "idUser TEXT PRIMARY KEY NOT NULL,"
            "phone TEXT NOT NULL,"
            "fullName TEXT NOT NULL,"
            "address TEXT NOT NULL,"
            "img TEXT NOT NULL,"
            "birthDate TEXT NOT NULL,"
            "dateEnter TEXT NOT NULL,"
            "status TEXT NOT NULL,"
            "gender TEXT NOT NULL,"
            "email TEXT NOT NULL)"
        );
        await database.execute("CREATE TABLE History("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "name TEXT NOT NULL)"
        );
      },
      version: 1,
    );
  }

  // Card Method
  List<Cart> listCart = [];
  List<Favorite> listFavorite = [];
  List<UserSQ> listUser = [];
  List<HistorySearch> listHistorySearch = [];

  Future<void> retrieveCarts() async {
    final Database db = await initializeDB();
    await db.transaction((txn) async {
      final List<Map<String, Object?>> queryResult = await txn.query('Cart');
      listCart = queryResult.map((e) => Cart.fromMap(e)).toList();
    });
    //return queryResult.map((e) => Cart.fromMap(e)).toList();
  }
  Future<void> retrieveUser() async {
    final Database db = await initializeDB();
    await db.transaction((txn) async {
      final List<Map<String, Object?>> queryResult = await txn.query('UserSQ');
      listUser = queryResult.map((e) => UserSQ.fromMap(e)).toList();
    });
    //return queryResult.map((e) => UserSQ.fromMap(e)).toList();
  }
  Future<void> retrieveFavorites() async {
    final Database db = await initializeDB();
    await db.transaction((txn) async {
      final List<Map<String, Object?>> queryResult = await txn.query(
          'Favorite');
      listFavorite = queryResult.map((e) => Favorite.fromMap(e)).toList();
    });
    //return queryResult.map((e) => Favorite.fromMap(e)).toList();
  }
  Future<void> retrieveHisSearch() async {
    final Database db = await initializeDB();
    await db.transaction((txn) async {
      final List<Map<String, Object?>> queryResult = await txn.query('History');
      listHistorySearch = queryResult.map((e) => HistorySearch.fromMap(e)).toList();
    });
    //return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> insertCart(Cart cart) async {
    int result = 0;
    final Database db = await initializeDB();
    List<Cart> listOldCart = getListCart;
    int? idCart = -1;
    int quantity = 0;

    for(var ca in listOldCart) {
      if(ca.idProduct == cart.idProduct) {
        idCart = ca.idCart;
        quantity = ca.quantity;
        break;
      }
    }

    await db.transaction((txn) async {
      if(idCart == -1) {
        result = await txn.insert('Cart', cart.toMap());
      }
      else {
        result = await txn.update(
          'Cart',
          {'quantity': quantity + 1},
          where: 'idCart = ?',
          whereArgs: [idCart],
        );
      }
    });

    return result;
  }
  Future<void> deleteCart(int idCart) async {
    final db = await initializeDB();
    await db.transaction((txn) async {
      await txn.delete(
      'Cart',
      where: "idCart = ?",
      whereArgs: [idCart],
      );
    });
  }
  Future<void> updateCart(int idCart, int quantity) async {
    final db = await initializeDB();
   await db.transaction((txn) async {
     await txn.update(
       'Cart',
       {'quantity': quantity},
       where: 'idCart = ?',
       whereArgs: [idCart],
     );
   });
  }
  Future<int> insertFavorite(Favorite favorite) async {

    int result = 0;
    final Database db = await initializeDB();
    List<Favorite> favoriteList = getListFavorite;
    favoriteList = favoriteList.where((element) => element.idProduct == favorite.idProduct).toList();

    if(favoriteList.isNotEmpty) {
      deleteFavorite(favoriteList[0].idFavorite!);
    }
    else {
      await db.transaction((txn) async {
        result = await txn.insert('Favorite', favorite.toMap());
      });
    }
    return result;
  }
  Future<void> deleteFavorite(int idFavorite) async {
    final db = await initializeDB();
    await db.transaction((txn) async {
      await txn.delete(
        'Favorite',
        where: "idFavorite = ?",
        whereArgs: [idFavorite],
      );
    });
  }
  // User method
  Future<int> insertUser(UserSQ user) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('UserSQ', user.toMap());
    return result;
  }
  Future<void> deleteUser(int idUser) async {
    final db = await initializeDB();
    await db.delete(
      'UserSQ',
      where: "idUser = ?",
      whereArgs: [idUser],
    );
  }

  List<UserSQ> get getListUser {
    retrieveUser();
    return listUser;
  }
  List<Cart> get getListCart {
    retrieveCarts();
    return listCart;
  }
  List<Favorite> get getListFavorite {
    retrieveFavorites();
    return listFavorite;
  }
  List<HistorySearch> get getListHistorySearch {
    retrieveHisSearch();
    return listHistorySearch;
  }
}
