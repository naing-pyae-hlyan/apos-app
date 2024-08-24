import 'package:apos_app/lib_exp.dart';

class FFirestoreUtils {
  static final _database = FirebaseFirestore.instance;
  static FirebaseFirestore get database => _database;

  // Get [category] table
  static CollectionReference<CategoryModel> get categoryCollection =>
      _database.collection("category").withConverter<CategoryModel>(
            fromFirestore: (snapshot, _) =>
                CategoryModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (category, _) => category.toJson(),
          );

  // Get [product] table
  static CollectionReference<ProductModel> get productCollection =>
      _database.collection("product").withConverter<ProductModel>(
            fromFirestore: (snapshot, _) =>
                ProductModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (product, _) => product.toJson(),
          );

  // Get [order] table
  static CollectionReference<OrderModel> get orderCollection =>
      _database.collection("order").withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (order, _) => order.toJson(),
          );

  // Get [customer] table
  static CollectionReference<CustomerModel> get customerCollection =>
      _database.collection("customer").withConverter<CustomerModel>(
            fromFirestore: (snapshot, _) =>
                CustomerModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (customer, _) => customer.toJson(),
          );

  static void listenOrderStatusChange() {
    orderCollection
        .where(
          "customer.id",
          isEqualTo: CacheManager.currentCustomer?.readableId,
        )
        .snapshots()
        .listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          String? message;
          if (data?.statusId == 1) {
            message = "Your payment is failed.";
          }
          if (data?.statusId == 2) {
            message = "Your payment is success.\nyour order is processing.";
          }
          if (data?.statusId == 3) {
            message = "Your order is delivered.\nThank your choosing us.";
          }

          if (message != null) {
            LocalNotiService.showNotification(
              "Order ID: ${data?.readableId}",
              message,
            );
            message = null;
            break;
          }
        }
      }
    });
  }
}
