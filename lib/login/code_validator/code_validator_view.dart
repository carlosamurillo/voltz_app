import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/login/code_validator/code_validator_view_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class CodeValidatorView extends StatelessWidget {
  const CodeValidatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CodeValidatorViewModel()..init(),
      child: const Scaffold(
        backgroundColor: CustomColors.blueVoltz,
        body: _CodeValidatorBody(),
      ),
    );
  }
}

class _CodeValidatorBody extends StatelessWidget {
  const _CodeValidatorBody({Key? key}) : super(key: key);
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: CustomColors.dark,
                  ),
                ),
                const SizedBox(height: 5),
                const SelectableText(
                  "Ingresa tu código de acceso.",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    color: CustomColors.dark,
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  text: const TextSpan(
                    text: "Te enviamos un mensaje de texto, con el código, al número ",
                    style: TextStyle(fontSize: 14, color: CustomColors.dark),
                    children: [
                      TextSpan(
                        text: "+52 55 8146 4361",
                        style: TextStyle(fontSize: 14, color: CustomColors.blueVoltz),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const _PinPut(),
                const SizedBox(height: 75),
                PrimaryButton(
                  text: "Entrar",
                  onPressed: () {
                    //login button action
                    context.read<CodeValidatorViewModel>().enter();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinPut extends StatelessWidget {
  const _PinPut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 54,
      textStyle: const TextStyle(fontSize: 32, color: CustomColors.dark, fontWeight: FontWeight.w700),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.dark, width: 1.4),
        borderRadius: BorderRadius.circular(14.0),
        color: CustomColors.WBY,
      ),
    );

    return Column(
      children: [
        Pinput(
          length: 6,
          onChanged: context.read<CodeValidatorViewModel>().changeCode,
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
              color: context.watch<CodeValidatorViewModel>().isCodeError ? Colors.red : const Color(0xFFD3D3D3),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        context.watch<CodeValidatorViewModel>().isCodeError
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
