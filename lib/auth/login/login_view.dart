import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/auth/login/code_validator_view.dart';
import 'package:maketplace/auth/login/login_view_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColors.blueVoltz,
      body: _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isProcessing = context.watch<LoginViewModel>().isProcessing;

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
            child: Form(
              autovalidateMode: context.watch<LoginViewModel>().showErrorMessages ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/voltz_logo.svg',
                        width: 39.69,
                        height: 19.86,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const SelectableText(
                    "Identifícate para cotizar y comprar",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32.0,
                      color: CustomColors.dark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    prefixIcon: const SizedBox(
                      width: 20,
                      child: Center(child: Text("+52", style: TextStyle(fontSize: 16))),
                    ),
                    hintText: "Escribe tu número celular",
                    validator: (_) => context.read<LoginViewModel>().phoneNumber.fold(
                          (pInc) => 'El número de celular es inválido',
                          (pCorr) => null,
                        ),
                    onChanged: (value) => context.read<LoginViewModel>().changePhoneNumber(value),
                  ),
                  const SizedBox(height: 21),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: CupertinoSwitch(
                          value: context.watch<LoginViewModel>().isWhatsappCheckboxAccepted,
                          onChanged: (v) => context.read<LoginViewModel>().checkboxWhatsappChanged(),
                          activeColor: CustomColors.blueVoltz,
                        ),
                      ),
                      const Expanded(child: Text("Acepto recibir mensajes por Whatsapp/SMS")),
                    ],
                  ),
                  const SizedBox(height: 80),
                  if (isProcessing)
                    const SingleChildScrollView()
                  else
                    Selector<LoginViewModel, LoginScreenStatus>(
                      builder: (context, status, child) {
                        switch (status) {
                          case LoginScreenStatus.inputCodeScreen:
                            Future.delayed(const Duration(seconds: 0), () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const CodeValidatorView()));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: SelectableText(
                                  "Ingrese el código de verificación.",
                                  style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
                                ),
                                backgroundColor: CustomColors.energyGreen,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(milliseconds: 2000),
                                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                onVisible: () async {},
                              ));
                            });
                            return const _LoginButton();
                          case LoginScreenStatus.failure:
                            Future.delayed(const Duration(seconds: 0), () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: SelectableText(
                                  "Error, vuelva a intentarlo.",
                                  style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
                                ),
                                backgroundColor: CustomColors.redAlert,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(milliseconds: 2000),
                                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                onVisible: () async {},
                              ));
                            });
                            return const _LoginButton();
                          default:
                            return const _LoginButton();
                        }
                      },
                      selector: (_, vm) => vm.loginScreenStatus,
                    ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: "Al hacer click en ",
                      style: TextStyle(fontSize: 12, color: CustomColors.darkMinusOne),
                      children: [
                        TextSpan(
                          text: "\"Continuar\"",
                          style: TextStyle(fontSize: 12, color: CustomColors.dark),
                        ),
                        TextSpan(
                          text: " acepto los ",
                        ),
                        TextSpan(
                          text: "Términos y condiciones y Política de privacidad.",
                          style: TextStyle(fontSize: 12, color: CustomColors.dark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: "Continuar",
      onPressed: () {
        FocusScope.of(context).unfocus();
        context.read<LoginViewModel>().login();
      },
    );
  }
}