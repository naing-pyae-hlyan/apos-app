import 'dart:convert';

import 'package:apos_app/lib_exp.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final double itemWidth;
  final bool isFav;
  final Function() onPressed;
  const ProductItem({
    super.key,
    required this.itemWidth,
    required this.product,
    this.isFav = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final image = MyCard(
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
    );
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
              child: isFav
                  ? Stack(
                      alignment: Alignment.topRight,
                      children: [
                        image,
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.favorite,
                            color: Consts.primaryColor,
                          ),
                        ),
                      ],
                    )
                  : image,
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
