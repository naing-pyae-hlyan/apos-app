import 'dart:convert';

import 'package:apos_app/lib_exp.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final double itemWidth;
  final Function() onPressed;
  const ProductItem({
    super.key,
    required this.itemWidth,
    required this.product,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Clickable(
            onTap: () => context.push(ProductDetailsPage(product: product)),
            radius: 12,
            child: Hero(
              tag: product.readableId,
              child: MyCard(
                elevation: 6,
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(product.base64Images.first),
                    fit: BoxFit.contain,
                    width: itemWidth,
                    height: itemWidth,
                  ),
                ),
              ),
            ),
          ),
          verticalHeight8,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: myText(product.name),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: myText(
              product.price.toCurrencyFormat(countryIso: "MMK"),
              color: Consts.descriptionColor,
            ),
          ),
        ],
      ),
    );
  }
}
