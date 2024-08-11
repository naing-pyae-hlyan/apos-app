import 'dart:convert';
import 'package:apos_app/lib_exp.dart';
import 'package:apos_app/views/pages/nav_products/submit_order_page.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late CartBloc cartBloc;

  void _onItemChangeEachItem(ItemModel item, int newQty) {
    cartBloc.add(CartEventChangeItemQty(itemId: item.id, newQty: newQty));
  }

  void _onItemRemove(ItemModel item) {
    cartBloc.add(CartEventRemoveItem(itemId: item.id));
  }

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: myAppBar(
        title: BlocBuilder<CartBloc, CartState>(builder: (_, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myTitle(
                "Total Payable:",
                color: Consts.primaryColor,
              ),
              myTitle(
                cartBloc.totalItemsAmount.toCurrencyFormat(countryIso: "MMK"),
                color: Consts.currencyGreen,
              ),
            ],
          );
        }),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            verticalHeight8,
            BlocBuilder<CartBloc, CartState>(
              builder: (_, state) {
                if (cartBloc.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalHeight64,
                        myText("Cart is Empty!"),
                        verticalHeight8,
                        const Icon(
                          Icons.remove_shopping_cart,
                          size: 64,
                        )
                      ],
                    ),
                  );
                }
                final List<ItemModel> items = cartBloc.items;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) => _itemListTile(items[index]),
                  separatorBuilder: (_, __) => verticalHeight8,
                  itemCount: items.length,
                );
              },
            ),
            verticalHeight128,
          ],
        ),
      ),
      fab: floatingActionButton(
        onPressed: () async {
          if (cartBloc.items.isEmpty) return;
          var result = await context.push(const SubmitOrderPage());
          if (mounted && result == true) {
            // close order_summary_page
            // ignore: use_build_context_synchronously
            context.pop(result: true);
          }
        },
        iconData: Icons.shopping_cart_checkout,
        heroTag: heroTagCart,
      ),
    );
  }

  Widget _itemListTile(ItemModel item) {
    final bool typeIsNotEmpty = item.types.isNotEmpty == true;
    final bool colorIsNotEmpty = item.colors.isNotEmpty == true;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Clickable(
          onTap: () {
            if (item.product != null) {
              context.push(ProductDetailsPage(
                product: item.product!,
                item: item,
              ));
            }
          },
          child: MyCard(
            elevation: 6,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      leadingProductImage(
                        (item.product?.base64Images ?? []).first,
                      ),
                      horizontalWidth16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            myText(item.name, fontWeight: FontWeight.w700),
                            if (item.product?.description?.isNotEmpty == true)
                              myText(
                                item.product?.description,
                                color: Consts.descriptionColor,
                                fontSize: 12,
                              ),
                            verticalHeight4,
                            myText(
                              "Price : ${item.price.toCurrencyFormat(countryIso: "MMK")}",
                              fontWeight: FontWeight.w700,
                              color: Consts.currencyGreen,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: Consts.scaffoldBackgroundColor,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (typeIsNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            myText("Type:"),
                            myText(item.types.join(",")),
                          ],
                        ),
                      if (colorIsNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            myText("Color:"),
                            Wrap(
                              spacing: 8,
                              children: item.colors
                                  .map((int color) => circularColor(color))
                                  .toList(),
                            ),
                          ],
                        ),
                      if (typeIsNotEmpty || colorIsNotEmpty) const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText("Qty:"),
                          myText("(${item.qty})"),
                        ],
                      ),
                      verticalHeight2,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText("Sub Total:"),
                          myText(
                            item.totalAmount
                                .toCurrencyFormat(countryIso: "MMK"),
                            color: Consts.currencyGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                      verticalHeight4,
                      QtyButton(
                        key: UniqueKey(),
                        qty: item.qty,
                        needTitle: false,
                        onQtyChanged: (int qty) =>
                            _onItemChangeEachItem(item, qty),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => _onItemRemove(item),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
