import 'package:apos_app/lib_exp.dart';

class SubmitOrderPage extends StatefulWidget {
  const SubmitOrderPage({super.key});

  @override
  State<SubmitOrderPage> createState() => _SubmitOrderPageState();
}

class _SubmitOrderPageState extends State<SubmitOrderPage> {
  late CartBloc cartBloc;
  final base64PaymentSsNotifier = ValueNotifier<String?>(null);
  final bankNotifier = ValueNotifier<MMBank?>(null);
  int _currentStep = 0;

  next() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  back() {
    if (_currentStep == 0) return;
    setState(() {
      _currentStep -= 1;
    });
  }

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: myAppBar(
        title: myTitle("Submit Orders"),
        elevation: 0,
      ),
      padding: EdgeInsets.zero,
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        elevation: 16,
        margin: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        onStepTapped: (int step) {
          // if (_currentStep == step) return;
          // setState(() {
          //   _currentStep = step;
          // });
        },
        controlsBuilder: (_, __) => emptyUI,
        steps: [
          Step(
            title: Flexible(child: myTitle("Order Info")),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.disabled,
            content: StepOrderInfo(
              items: cartBloc.items,
              totalItemsAmount: cartBloc.totalItemsAmount,
              onTapNext: next,
              onTapCancel: () => context.pop(result: false),
            ),
          ),
          Step(
            title: myTitle("Payment"),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.disabled,
            content: StepPaymentInfo(
              bankNotifier: bankNotifier,
              base64PaymentSsNotifier: base64PaymentSsNotifier,
              onTapBack: back,
              onTapNext: next,
            ),
          ),
          Step(
            title: Flexible(child: myTitle("Confirm")),
            isActive: _currentStep == 2,
            state: _currentStep > 2 ? StepState.complete : StepState.disabled,
            content: StepConfirm(
              items: cartBloc.items,
              totalItemsAmount: cartBloc.totalItemsAmount,
              payBy: bankNotifier.value?.name ?? "Cash",
              base64PaymentSS: base64PaymentSsNotifier.value,
              onTapBack: back,
            ),
          ),
        ],
      ),
    );
  }
}
