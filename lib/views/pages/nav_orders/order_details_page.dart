import 'package:apos_app/lib_exp.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: myAppBar(
        elevation: 0,
        title: myTitle("Order# ${order.readableId}"),
        centerTitle: false,
      ),
      padding: EdgeInsets.zero,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            verticalHeight8,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                myText("Order Date: "),
                myText(order.orderDate.toDDmmYYYYHHmm()),
                horizontalWidth16,
              ],
            ),
            verticalHeight8,
            Divider(color: Colors.grey[300], thickness: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _itemRow(
                qty: myTitle("Qty"),
                item: myTitle("Items"),
                amount: myTitle("Amount", textAlign: TextAlign.end),
              ),
            ),
            Divider(color: Colors.grey[300], thickness: 8),
            verticalHeight8,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => _item(order.items[index]),
              separatorBuilder: (_, __) => const Divider(thickness: 0.3),
              itemCount: order.items.length,
            ),
            verticalHeight16,
            Divider(color: Colors.grey[300], thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myText("Status: ", fontWeight: FontWeight.normal),
                  myText(
                    order.status.name,
                    color: order.status.color,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myText("Pay By: ", fontWeight: FontWeight.normal),
                  myText(order.payment),
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTitle("Total: ", fontWeight: FontWeight.normal),
                  myTitle(
                    order.totalAmount.toCurrencyFormat(countryIso: "MMK"),
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(ItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _itemRow(
        qty: myText("${item.qty}", textAlign: TextAlign.center),
        item: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myText(item.name, fontWeight: FontWeight.w700),
            if (item.product?.description?.isNotEmpty == true)
              myText(
                item.product?.description,
                color: Consts.descriptionColor,
                fontSize: 12,
              ),
            if (item.types.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myText("Type:", fontSize: 12, color: Consts.descriptionColor),
                  myText(
                    item.types.join(","),
                    fontSize: 12,
                    color: Consts.descriptionColor,
                  ),
                ],
              ),
            if (item.colors.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myText("Color", fontSize: 12, color: Consts.descriptionColor),
                  Wrap(
                    spacing: 8,
                    children: item.colors
                        .map((int color) => circularColor(color))
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
        amount: myText(
          item.totalAmount.toCurrencyFormat(),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  Widget _itemRow({
    required Widget qty,
    required Widget item,
    required Widget amount,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 48, child: qty),
          Expanded(child: item),
          SizedBox(width: 96, child: amount),
        ],
      );
}
