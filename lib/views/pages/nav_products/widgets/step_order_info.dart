import 'package:apos_app/lib_exp.dart';

class StepOrderInfo extends StatelessWidget {
  final List<ItemModel> items;
  final int totalItemsAmount;
  final Function() onTapNext;
  final Function() onTapCancel;
  const StepOrderInfo({
    super.key,
    required this.items,
    required this.totalItemsAmount,
    required this.onTapCancel,
    required this.onTapNext,
  });
  @override
  Widget build(BuildContext context) {
    return MyStep(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MyButton(
              label: "Cancel",
              icon: Icons.cancel,
              backgroundColor: Consts.secondaryColor,
              labelColor: Consts.primaryColor,
              onPressed: onTapCancel,
            ),
          ),
          horizontalWidth12,
          Expanded(
            child: MyButton(
              label: "Payment",
              icon: Icons.arrow_forward_sharp,
              onPressed: onTapNext,
            ),
          ),
        ],
      ),
      children: [
        tableRow(
          item: myTitle("Items"),
          qty: myTitle("Qty"),
          amount: myTitle("Amount", textAlign: TextAlign.end),
        ),
        verticalHeight8,
        const MySeparator(),
        verticalHeight8,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => productItem(items[index]),
          separatorBuilder: (_, __) => verticalHeight8,
          itemCount: items.length,
        ),
        verticalHeight8,
        const MySeparator(),
        verticalHeight8,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            myTitle("Total:"),
            SizedBox(
              width: 120,
              child: myTitle(
                totalItemsAmount.toCurrencyFormat(),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        verticalHeight24,
      ],
    );
  }

  Widget productItem(ItemModel item) {
    return tableRow(
      qty: myText("${item.qty}", textAlign: TextAlign.center),
      item: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myText(item.name, fontWeight: FontWeight.w600),
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
    );
  }

  Widget tableRow({
    required Widget qty,
    required Widget item,
    required Widget amount,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: item),
          SizedBox(width: 48, child: qty),
          SizedBox(width: 96, child: amount),
        ],
      );
}
