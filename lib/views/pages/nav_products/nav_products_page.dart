import 'dart:convert';

import 'package:apos_app/lib_exp.dart';

class NavProductsPage extends StatefulWidget {
  const NavProductsPage({super.key});

  @override
  State<NavProductsPage> createState() => _NavProductsPageState();
}

class _NavProductsPageState extends State<NavProductsPage> {
  double itemWidth = 120;
  @override
  Widget build(BuildContext context) {
    itemWidth = context.screenWidth * 0.3 - 8;
    return MyScaffold(
      appBar: const ItemsAppBar(),
      body: Column(
        children: [
          verticalHeight16,
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                return _listTile(CacheManager.categories[index]);
              },
              separatorBuilder: (_, __) => verticalHeight4,
              itemCount: CacheManager.categories.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTile(CategoryModel category) {
    final List<ProductModel> products = CacheManager.products
        .where((ProductModel product) => category.id == product.categoryId)
        .toList();
    if (products.isEmpty) return emptyUI;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: myTitle(category.name, maxLines: 2),
            ),
            horizontalWidth4,
            myText("(${products.length})"),
          ],
        ),
        verticalHeight8,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: List.generate(
            products.take(3).length,
            (index) => _productItem(products[index]),
          ),
        ),
      ],
    );
  }

  Widget _productItem(ProductModel product) => SizedBox(
        width: itemWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Clickable(
              onTap: () {},
              // onTap: () => context.push(ProductDetailsPage(product: product)),
              radius: 16,
              child: Hero(
                tag: product.readableId,
                child: MyCard(
                  child: Image.memory(
                    base64Decode(product.base64Images.first),
                    fit: BoxFit.contain,
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
