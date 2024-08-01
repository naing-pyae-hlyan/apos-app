import 'package:apos_app/lib_exp.dart';

class FFirestoreUtils {
  static final _database = FirebaseFirestore.instance;
  static FirebaseFirestore get database => _database;

  // Get [category] table
  static CollectionReference<Category> get categoryCollection =>
      _database.collection("category").withConverter<Category>(
            fromFirestore: (snapshot, _) =>
                Category.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (category, _) => category.toJson(),
          );

  // Get [product] table
  static CollectionReference<Product> get productCollection =>
      _database.collection("product").withConverter<Product>(
            fromFirestore: (snapshot, _) =>
                Product.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (product, _) => product.toJson(),
          );

  // Get [order] table
  static CollectionReference<Order> get orderCollection =>
      _database.collection("order").withConverter<Order>(
            fromFirestore: (snapshot, _) =>
                Order.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (product, _) => product.toJson(),
          );

  // Get [customer] table
  static CollectionReference<Customer> get customerCollection =>
      _database.collection("customer").withConverter<Customer>(
            fromFirestore: (snapshot, _) =>
                Customer.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (product, _) => product.toJson(),
          );
}
