import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/login/login_view_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel()..init(),
      child: const Scaffold(
        backgroundColor: CustomColors.blueVoltz,
        body: _LoginBody(),
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                  controller: context.read<LoginViewModel>().loginController,
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
                PrimaryButton(
                  text: "Continuar",
                  onPressed: () {
                    //login button action
                    context.read<LoginViewModel>().login();
                  },
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
    );
  }
}
