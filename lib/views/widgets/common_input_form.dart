import 'package:apos_app/lib_exp.dart';

class MyInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? title;
  final String? hintText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscure;
  final String? errorKey;
  final int maxLines;
  const MyInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.title,
    this.hintText,
    this.readOnly = false,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscure = false,
    required this.errorKey,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (title != null) myText(title, fontWeight: FontWeight.w800),
        if (title != null) verticalHeight8,
        TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            filled: true,
            fillColor: Consts.inputFieldPlaceholderColor,
            border: outlineInputBorder,
            errorBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            disabledBorder: outlineInputBorder,
            focusedErrorBorder: outlineInputBorder,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Consts.hintColor,
              fontSize: 13,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
        BlocBuilder<ErrorBloc, ErrorState>(
          builder: (_, state) {
            if (state is ErrorStateHasError) {
              if (state.errorKey == errorKey) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: errorText(state.error.message),
                );
              }
            }

            return emptyUI;
          },
        ),
      ],
    );
  }

  OutlineInputBorder get outlineInputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Consts.inputFieldPlaceholderColor,
        ),
      );
}

class MyPasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? title;
  final String? hintText;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorKey;
  const MyPasswordInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.title,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    required this.errorKey,
  });

  @override
  State<MyPasswordInputField> createState() => _MyPasswordInputFieldState();
}

class _MyPasswordInputFieldState extends State<MyPasswordInputField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return MyInputField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      title: widget.title,
      hintText: widget.hintText ?? "Password",
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      obscure: _obscure,
      errorKey: widget.errorKey,
      suffixIcon: Clickable(
        onTap: () {
          setState(() {
            _obscure = !_obscure;
          });
        },
        child: Icon(
          _obscure ? Icons.visibility : Icons.visibility_off,
          color: Consts.primaryColor,
        ),
      ),
    );
  }
}
