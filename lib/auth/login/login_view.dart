import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/auth/login/code_validator_view.dart';
import 'package:maketplace/auth/login/login_service.dart';
import 'package:maketplace/auth/login/login_view_model.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppKeys().customColors!.blueVoltz,
      body: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
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
                    child: Form(
                      autovalidateMode: model.showErrorMessages ? AutovalidateMode.always : AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                onPressed: () => model.navigateBack(),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          SelectableText(
                            "Identifícate para cotizar y comprar",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 32.0,
                              color: AppKeys().customColors!.dark,
                            ),
                          ),
                          const SizedBox(height: 15),
                          InputText(
                            prefixIcon: const SizedBox(
                              width: 20,
                              child: Center(child: Text("+52", style: TextStyle(fontSize: 16))),
                            ),
                            hintText: "Escribe tu número celular",
                            validator: (_) => model.phoneNumber.fold(
                              (pInc) => 'El número de celular es inválido',
                              (pCorr) => null,
                            ),
                            onChanged: (value) => model.changePhoneNumber(value),
                          ),
                          const SizedBox(height: 21),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 17),
                                child: CupertinoSwitch(
                                  value: model.isWhatsappCheckboxAccepted,
                                  onChanged: (v) => model.checkboxWhatsappChanged(),
                                  activeColor: AppKeys().customColors!.blueVoltz,
                                ),
                              ),
                              const Expanded(child: Text("Acepto recibir mensajes por Whatsapp/SMS")),
                            ],
                          ),
                          const SizedBox(height: 80),
                          if (model.isProcessing)
                            const SingleChildScrollView()
                          else
                            LayoutBuilder(
                              builder: (BuildContext ctx, BoxConstraints constraints) {
                                switch (model.loginScreenStatus) {
                                  case LoginScreenStatus.inputCodeScreen:
                                    Future.delayed(const Duration(seconds: 0), () {
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const CodeValidatorView()));
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: SelectableText(
                                          "Ingrese el código de verificación.",
                                          style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
                                        ),
                                        backgroundColor: AppKeys().customColors!.energyGreen,
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(milliseconds: 2000),
                                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                        onVisible: () async {},
                                      ));
                                    });
                                    return _LoginButton(
                                      onTap: model.login,
                                    );
                                  case LoginScreenStatus.failure:
                                    Future.delayed(const Duration(seconds: 0), () {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: SelectableText(
                                          "Error, vuelva a intentarlo.",
                                          style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
                                        ),
                                        backgroundColor: AppKeys().customColors!.redAlert,
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(milliseconds: 2000),
                                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                        onVisible: () async {},
                                      ));
                                    });
                                    return _LoginButton(
                                      onTap: model.login,
                                    );
                                  default:
                                    return _LoginButton(
                                      onTap: model.login,
                                    );
                                }
                              },
                            ),
                          const SizedBox(height: 10),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Al hacer click en ",
                              style: TextStyle(fontSize: 12, color: AppKeys().customColors!.dark1),
                              children: [
                                TextSpan(
                                  text: "\"Continuar\"",
                                  style: TextStyle(fontSize: 12, color: AppKeys().customColors!.dark),
                                ),
                                const TextSpan(
                                  text: " acepto los ",
                                ),
                                TextSpan(
                                  text: "Términos y condiciones y Política de privacidad.",
                                  style: TextStyle(fontSize: 12, color: AppKeys().customColors!.dark),
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
          }),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: "Continuar",
      onPressed: () {
        FocusScope.of(context).unfocus();
        onTap();
      },
    );
  }
}
