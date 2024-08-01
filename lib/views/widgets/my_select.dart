import 'package:apos_app/lib_exp.dart';

class MySelect extends StatelessWidget {
  final bool isSelected;
  final double size;
  final Color? selectBoxColor;
  const MySelect({
    super.key,
    required this.isSelected,
    this.selectBoxColor,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: Consts.primaryColor,
          width: 0.7,
        ),
        color: selectBoxColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: size - 14,
                height: size - 14,
                decoration: const BoxDecoration(
                  color: Consts.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey,
                      offset: Offset(0, 12),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
            )
          : emptyUI,
    );
  }
}

class MyCheckBoxWithLabel extends StatefulWidget {
  final bool? value;
  final String label;
  final double size;
  final MainAxisAlignment mainAxisAlignment;
  final Function(bool)? onSelected;
  const MyCheckBoxWithLabel({
    super.key,
    this.value = false,
    required this.label,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.onSelected,
    this.size = 20,
  });

  @override
  State<MyCheckBoxWithLabel> createState() => _MyCheckBoxWithLabelState();
}

class _MyCheckBoxWithLabelState extends State<MyCheckBoxWithLabel> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == true) {
      doAfterBuild(
        callback: () {
          setState(() {
            _isSelected = widget.value ?? false;
          });
        },
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: [
        myText(widget.label),
        horizontalWidth8,
        Clickable(
          onTap: () {
            setState(() {
              _isSelected = !_isSelected;
              if (widget.onSelected != null) {
                widget.onSelected!(_isSelected);
              }
            });
          },
          radius: 4,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              border: Border.all(
                color: Consts.primaryColor,
                width: 0.7,
              ),
              borderRadius: BorderRadius.circular(4),
              color: _isSelected ? Consts.primaryColor : Colors.white,
              shape: BoxShape.rectangle,
            ),
            child: _isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : emptyUI,
          ),
        ),
      ],
    );
  }
}
