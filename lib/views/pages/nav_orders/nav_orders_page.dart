import 'package:apos_app/lib_exp.dart';

class NavOrdersPage extends StatefulWidget {
  const NavOrdersPage({super.key});

  @override
  State<NavOrdersPage> createState() => _NavOrdersPageState();
}

class _NavOrdersPageState extends State<NavOrdersPage> {
  final searchTxtCtrl = TextEditingController();
  final ValueNotifier<String> searchCtrl = ValueNotifier("");
  final ValueNotifier<int> orderCountCtrl = ValueNotifier(0);

  @override
  void dispose() {
    if (mounted) {
      searchTxtCtrl.dispose();
    }
    super.dispose();
  }

  Widget? home;

  @override
  Widget build(BuildContext context) {
    home ??= MyScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalHeight8,
            ValueListenableBuilder(
              valueListenable: orderCountCtrl,
              builder: (_, int value, __) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: myTitle("My Orders ($value)"),
                );
              },
            ),
            verticalHeight8,
            MyInputField(
              controller: searchTxtCtrl,
              errorKey: null,
              hintText: "Search by order Id",
              onChanged: (String query) {
                searchCtrl.value = query;
                if (query.isEmpty) {
                  context.hideKeyboard();
                }
              },
              onSubmitted: (String query) {
                searchCtrl.value = query;
                if (query.isEmpty) {
                  context.hideKeyboard();
                }
              },
            ),
            verticalHeight8,
            StreamBuilder<QuerySnapshot<OrderModel>>(
              stream: FFirestoreUtils.orderCollection
                  .where(
                    "customer.id",
                    isEqualTo: CacheManager.currentCustomer?.readableId,
                  )
                  .orderBy("order_date", descending: true)
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const MyCircularIndicator();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: errorText(snapshot.error.toString()),
                  );
                }

                final List<OrderModel> orders = [];
                for (var doc in snapshot.requireData.docs) {
                  orders.add(doc.data());
                }
                doAfterBuild(callback: () {
                  orderCountCtrl.value = orders.length;
                });

                if (orders.isEmpty) return myText("Empty Orders");

                return ValueListenableBuilder(
                  valueListenable: searchCtrl,
                  builder: (_, String value, __) {
                    final List<OrderModel> search = [];

                    if (value.isNotEmpty) {
                      for (var order in orders) {
                        if (stringCompare(order.id, value) ||
                            stringCompare(order.readableId, value)) {
                          search.add(order);
                        }
                      }
                    }
                    return _orderTableView(
                      search.isEmpty ? orders : search,
                    );
                  },
                );
              },
            ),
            verticalHeight128,
          ],
        ),
      ),
    );
    return home!;
  }

  Widget _orderTableView(List<OrderModel> orders) => ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: orders.length,
        separatorBuilder: (_, __) => verticalHeight8,
        itemBuilder: (_, index) {
          final OrderModel order = orders[index];
          return Clickable(
            onTap: () => context.push(OrderDetailsPage(order: order)),
            child: MyCard(
              elevation: 6,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalHeight16,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: myText("Order# ${order.readableId}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: myText(
                      order.orderDate.toDDmmYYYYHHmm(),
                      color: Consts.descriptionColor,
                    ),
                  ),
                  verticalHeight16,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myTitle("Total:", fontWeight: FontWeight.w700),
                        myTitle(
                          order.totalAmount.toCurrencyFormat(countryIso: "MMK"),
                          color: Consts.currencyGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  verticalHeight16,
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      color: Consts.scaffoldBackgroundColor,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myText("Status", fontWeight: FontWeight.w700),
                        myText(
                          order.status.name,
                          fontWeight: FontWeight.w700,
                          color: order.status.color,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
