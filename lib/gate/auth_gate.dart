import 'package:flutter/material.dart';
import 'package:maketplace/gate/auth_gate_viewmodel.dart';
import 'package:maketplace/keys_model.dart';
import 'package:stacked/stacked.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key, this.quoteId, this.orderId}) : super(key: key);
  final String? quoteId;
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return ViewModelBuilder<AuthGateViewModel>.reactive(
      viewModelBuilder: () => AuthGateViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(quoteId: quoteId, orderId: orderId),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: false,
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppKeys().customColors!.WBY,
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
