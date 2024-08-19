import 'package:apos_app/lib_exp.dart';

void showCustomerUpdateDialog(
  BuildContext context, {
  required CustomerUpdateAction action,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CustomerUpdateDialog(
        action: action,
      ),
    );

const _dynamicEditErrorKey = "dynamic-edit-error-key";
const _passwordEditErrorKey = "password-edit-error-key";

class _CustomerUpdateDialog extends StatefulWidget {
  final CustomerUpdateAction action;
  const _CustomerUpdateDialog({
    required this.action,
  });

  @override
  State<_CustomerUpdateDialog> createState() => __CustomerUpdateDialogState();
}

class __CustomerUpdateDialogState extends State<_CustomerUpdateDialog> {
  late AuthBloc authBloc;
  late ErrorBloc errorBloc;

  final dynamicTxtCtrl = TextEditingController();
  final passwordTxtCtrl = TextEditingController();
  final dynamicFn = FocusNode();
  final passwordFn = FocusNode();

  void _onUpdate() {
    if (widget.action == CustomerUpdateAction.emial ||
        widget.action == CustomerUpdateAction.phone ||
        widget.action == CustomerUpdateAction.password) {
      authBloc.add(
        AuthEventUpdateCustomerDataRequestOTP(
          action: widget.action,
          newValue: dynamicTxtCtrl.text,
          password: passwordTxtCtrl.text,
        ),
      );
      return;
    }
    final hashPassword = HashUtils.hashPassword(passwordTxtCtrl.text);
    authBloc.add(
      AuthEventUpdateCustomerData(
        needToValidate: true,
        action: widget.action,
        newValue: dynamicTxtCtrl.text,
        password: hashPassword,
      ),
    );
  }

  void _updateListener(BuildContext context, AuthState state) async {
    if (state is AuthStateUpdateCustomerRequestOTP) {
      showOTPDialog(
        context,
        onSuccess: () {
          authBloc.add(AuthEventUpdateCustomerData(
            needToValidate: false,
            action: state.action,
            newValue: state.newValue,
            password: state.password,
          ));
        },
      );
    }

    if (state is AuthStateUpdateCustomerDataSuccess) {
      // Close current popup dialog
      context.pop(result: true);

      switch (state.action) {
        case CustomerUpdateAction.name:
          break;
        case CustomerUpdateAction.phone:
          break;
        case CustomerUpdateAction.address:
          break;
        case CustomerUpdateAction.emial:
          await SpHelper.setEmail(state.newValue);
          break;
        case CustomerUpdateAction.password:
          await SpHelper.setPassword(state.password);
          break;
      }
      if (mounted) {
        // ignore: use_build_context_synchronously
        context.pushAndRemoveUntil(const SplashPage());
      }
    }

    if (state is AuthStateFail) {
      String? errorKey;
      if (state.error.code == 1) {
        dynamicFn.requestFocus();
        errorKey = _dynamicEditErrorKey;
      } else if (state.error.code == 2) {
        passwordFn.requestFocus();
        errorKey = _passwordEditErrorKey;
      }
      errorBloc.add(ErrorEventSetError(
        errorKey: errorKey,
        error: state.error,
      ));
    }
  }

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    errorBloc = context.read<ErrorBloc>();
    super.initState();

    doAfterBuild(
      callback: () {
        dynamicFn.requestFocus();
        errorBloc.add(ErrorEventResert());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      icon: const Icon(
        Icons.account_circle_rounded,
        color: Consts.primaryColor,
        size: 96,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dynamicInputField,
          verticalHeight16,
          MyPasswordInputField(
            controller: passwordTxtCtrl,
            focusNode: passwordFn,
            hintText: widget.action == CustomerUpdateAction.password
                ? "New password"
                : "Enter password",
            errorKey: _passwordEditErrorKey,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: myText('Cancel'),
        ),
        BlocConsumer<AuthBloc, AuthState>(
          listener: _updateListener,
          builder: (_, state) {
            if (state is AuthStateLoading) {
              return const MyCircularIndicator();
            }
            return TextButton(
              onPressed: _onUpdate,
              style: TextButton.styleFrom(
                backgroundColor: Consts.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: myText("UPDATE", color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget get dynamicInputField {
    if (widget.action == CustomerUpdateAction.password) {
      return MyPasswordInputField(
        controller: dynamicTxtCtrl,
        focusNode: dynamicFn,
        hintText: "Enter old password",
        errorKey: _dynamicEditErrorKey,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
      );
    } else {
      return MyInputField(
        controller: dynamicTxtCtrl,
        focusNode: dynamicFn,
        hintText: "Enter new ${widget.action.name}",
        errorKey: _dynamicEditErrorKey,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        maxLines: widget.action == CustomerUpdateAction.address ? 4 : 1,
      );
    }
  }
}
