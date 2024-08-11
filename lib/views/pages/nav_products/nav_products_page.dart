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
      padding: EdgeInsets.zero,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return _listTile(CacheManager.categories[index]);
                  },
                  separatorBuilder: (_, __) => verticalHeight8,
                  itemCount: CacheManager.categories.length,
                ),
                verticalHeight128,
              ],
            ),
          ),
          const ItemCart(),
        ],
      ),
    );
  }

  Widget _listTile(CategoryModel category) {
    final List<ProductModel> products = CacheManager.products
        .where((ProductModel product) => category.id == product.categoryId)
        .toList();
    if (products.isEmpty) return emptyUI;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalHeight16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              horizontalWidth4,
              Flexible(
                child: myTitle(category.name, maxLines: 2),
              ),
              horizontalWidth4,
              myText("(${products.length})"),
            ],
          ),
          verticalHeight8,
          MyCard(
            cardColor: Consts.secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                    products.take(3).length,
                    (index) => ProductItem(
                      itemWidth: itemWidth,
                      product: products[index],
                      onPressed: () {
                        context.push(
                          ProductDetailsPage(product: products[index]),
                        );
                      },
                    ),
                  ),
                ),
                if (products.length > 3) ...[
                  verticalHeight8,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Clickable(
                      onTap: () {
                        context.push(MoreProductsPage(
                          category: category,
                          products: products,
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: myText("View All", color: Consts.primaryColor),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
