
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:maketplace/gate/auth_gate_viewmodel.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key, this.quoteId}) : super(key: key);
  final String? quoteId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthGateViewModel>.reactive(
      viewModelBuilder: () => AuthGateViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(quoteId: quoteId),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: false,
      builder: (context, model, child) {
        return const Scaffold(
          backgroundColor: CustomColors.WBY,
          body: Center(
              child: CircularProgressIndicator()
          ),
        );
      },
    );
  }
}