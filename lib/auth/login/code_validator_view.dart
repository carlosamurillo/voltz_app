import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/auth/login/login_service.dart';
import 'package:maketplace/auth/login/login_view_model.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/style.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class CodeValidatorView extends StatelessWidget {
  const CodeValidatorView({Key? key, this.quoteId, this.orderId}) : super(key: key);
  final String? quoteId;
  final String? orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppKeys().customColors!.blueVoltz,
      body: _CodeValidatorBody(quoteId: quoteId, orderId: orderId),
    );
  }
}

class _CodeValidatorBody extends StatelessWidget {
  const _CodeValidatorBody({Key? key, this.quoteId, this.orderId}) : super(key: key);
  final String? quoteId;
  final String? orderId;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel()..init(quoteId, orderId),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return SafeArea(
          child: LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              AppKeys().logo!,
                              width: 39.69,
                              height: 19.86,
                            ),
                            IconButton(
                              onPressed: () => model.navigateToHomeClearingAll(),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        SelectableText(
                          "Bienvenido",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppKeys().customColors!.dark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SelectableText(
                          "Ingresa tu código de acceso.",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 32.0,
                            color: AppKeys().customColors!.dark,
                          ),
                        ),
                        const SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: "Te enviamos un mensaje de texto, con el código, al número ",
                            style: TextStyle(fontSize: 14, color: AppKeys().customColors!.dark),
                            children: [
                              TextSpan(
                                text: context.read<LoginViewModel>().phoneNumber.getOrElse(() => ""),
                                style: TextStyle(fontSize: 14, color: AppKeys().customColors!.blueVoltz),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const _PinPut(),
                        const SizedBox(height: 75),
                        if (model.isProcessing)
                          const Center(child: CircularProgressIndicator())
                        else
                          LayoutBuilder(
                            builder: (BuildContext ctx, BoxConstraints constraints) {
                              switch (model.loginScreenStatus) {
                                case LoginScreenStatus.registerScreen:
                                  Future.delayed(const Duration(seconds: 0), () {
                                    //
                                    model.navigateToRegisterView(model.phoneNumber.getOrElse(() => "INVALID PHONE"));

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: SelectableText(
                                        "Necesitamos crear tu usuario.",
                                        style: CustomStyles.styleVolcanicDos,
                                      ),
                                      backgroundColor: AppKeys().customColors!.energyColor,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(milliseconds: 2000),
                                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                      onVisible: () async {},
                                    ));
                                  });
                                  return const _ActionButton();
                                case LoginScreenStatus.overview:
                                  Future.delayed(const Duration(seconds: 0), () {
                                    //
                                    model.navigateLoginSuccess();

                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: SelectableText(
                                        "Bienvenido.",
                                        style: CustomStyles.styleVolcanicDos,
                                      ),
                                      backgroundColor: AppKeys().customColors!.energyColor,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(milliseconds: 2000),
                                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                      onVisible: () async {},
                                    ));
                                  });
                                  return const _ActionButton();
                                case LoginScreenStatus.failure:
                                  Future.delayed(const Duration(seconds: 0), () {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: SelectableText(
                                        "Error, el código es incorrecto.",
                                        style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
                                      ),
                                      backgroundColor: AppKeys().customColors!.redAlert,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(milliseconds: 2000),
                                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                      onVisible: () async {},
                                    ));
                                  });
                                  return const _ActionButton();
                                default:
                                  return const _ActionButton();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ActionButton extends StackedHookView<LoginViewModel> {
  const _ActionButton({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel model,
  ) {
    return PrimaryButton(
      text: "Entrar",
      enabled: model.checkCodeButtonEnabled,
      onPressed: () {
        if (model.checkCodeButtonEnabled) {
          FocusScope.of(context).unfocus();
          model.validateCode();
        }
      },
    );
  }
}

class _PinPut extends StackedHookView<LoginViewModel> {
  const _PinPut({
    Key? key,
  }) : super(key: key);

  @override
  Widget builder(BuildContext context, LoginViewModel model) {
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 54,
      textStyle: TextStyle(fontSize: 32, color: AppKeys().customColors!.dark, fontWeight: FontWeight.w700),
      decoration: BoxDecoration(
        border: Border.all(color: AppKeys().customColors!.dark, width: 1.4),
        borderRadius: BorderRadius.circular(14.0),
        color: AppKeys().customColors!.WBY,
      ),
    );

    return Column(
      children: [
        Pinput(
          length: 6,
          onChanged: (value) => model.changeCode(value),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          ],
          pinAnimationType: PinAnimationType.none,
          defaultPinTheme: defaultPinTheme,
          submittedPinTheme: defaultPinTheme.copyDecorationWith(
            borderRadius: BorderRadius.circular(5.0),
          ),
          followingPinTheme: defaultPinTheme.copyDecorationWith(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: model.codeNumber.isLeft() ? Colors.red : const Color(0xFFD3D3D3),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (model.showErrorMessages)
          model.codeNumber.isLeft()
              ? Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Código incorrecto, vuelva a intentarlo",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Container()
      ],
    );
  }
}
