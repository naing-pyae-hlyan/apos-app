import 'dart:convert';

import 'package:apos_app/lib_exp.dart';

class SwipeableImages extends StatefulWidget {
  final List<String> base64Images;
  final String heroTag;
  const SwipeableImages({
    super.key,
    required this.base64Images,
    required this.heroTag,
  });

  @override
  State<SwipeableImages> createState() => _SwipeableImagesState();
}

class _SwipeableImagesState extends State<SwipeableImages> {
  int currentImageIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    pageController = PageController(
      viewportFraction: 1,
      initialPage: currentImageIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageWidth = context.screenWidth * 0.7;
    return SizedBox(
      height: imageWidth + 16,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            pageSnapping: true,
            controller: pageController,
            itemCount: widget.base64Images.length,
            onPageChanged: (page) {
              setState(() => currentImageIndex = page);
            },
            itemBuilder: (_, index) {
              final Uint8List image = base64Decode(widget.base64Images[index]);
              return Hero(
                tag: widget.heroTag,
                child: Image.memory(
                  image,
                  width: imageWidth,
                  height: imageWidth,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          if (widget.base64Images.length > 1)
            Padding(
              padding: const EdgeInsets.all(4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _indicators(
                    onTap: (int index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear,
                      );
                    },
                    length: widget.base64Images.length,
                    currentIndex: currentImageIndex,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _indicators({
    required final Function(int index) onTap,
    required final int length,
    required final int currentIndex,
  }) =>
      List<Widget>.generate(
        length,
        (index) => Clickable(
          radius: 16,
          onTap: () => onTap(index),
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: currentIndex == index
                  ? Consts.primaryColor
                  : Colors.grey[300],
              // shape: BoxShape.circle,
              // border: Border.all(color: Consts.primaryColor),
            ),
          ),
        ),
      );
}
