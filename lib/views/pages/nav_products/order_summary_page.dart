import 'dart:convert';

import 'package:apos_app/lib_exp.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late CartBloc cartBloc;

  void _onItemChangeEachItem(ItemModel item, int newQty) {
    if (item.id == null) return;
    cartBloc.add(CartEventChangeItemQty(itemId: item.id!, newQty: newQty));
  }

  void _onItemRemove(ItemModel item) {
    if (item.id == null) return;
    cartBloc.add(CartEventRemoveItem(itemId: item.id!));
  }

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
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
        elevation: 16,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Consts.secondaryColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            verticalHeight8,
            BlocBuilder<CartBloc, CartState>(
              builder: (_, state) {
                if (state is CartStateLoading) {
                  return const MyCircularIndicator();
                }
                if (cartBloc.items.isEmpty) return emptyUI;
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
        onPressed: () {},
        iconData: Icons.shopping_cart_checkout,
        heroTag: heroTagCart,
      ),
    );
  }

  Widget _itemListTile(ItemModel item) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        MyCard(
          elevation: 6,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _itemListLeadingImage(
                        (item.product?.base64Images ?? []).first),
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
                      bottomRight: Radius.circular(12)),
                  color: Consts.secondaryColor,
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                          item.totalAmount.toCurrencyFormat(countryIso: "MMK"),
                          color: Consts.currencyGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    verticalHeight4,
                    QtyButton(
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
        IconButton(
          onPressed: () => _onItemRemove(item),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _itemListLeadingImage(String? image) {
    if (image == null) return _defaultNoImage;
    Uint8List? memory;
    try {
      memory = base64Decode(image);
    } catch (_) {}

    if (memory == null) return _defaultNoImage;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        memory,
        width: 64,
        height: 64,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _defaultNoImage,
      ),
    );
  }

  Widget get _defaultNoImage => Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
      );
}
