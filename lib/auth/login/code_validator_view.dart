import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/auth/login/login_service.dart';
import 'package:maketplace/auth/login/login_view_model.dart';
import 'package:maketplace/auth/register/register_view.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class CodeValidatorView extends StatelessWidget {
  const CodeValidatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColors.blueVoltz,
      body: _CodeValidatorBody(),
    );
  }
}

class _CodeValidatorBody extends StatelessWidget {
  const _CodeValidatorBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return SafeArea(
          child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints){
                return  Center(
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
                              text: TextSpan(
                                text: "Te enviamos un mensaje de texto, con el código, al número ",
                                style: const TextStyle(fontSize: 14, color: CustomColors.dark),
                                children: [
                                  TextSpan(
                                    text: context.read<LoginViewModel>().phoneNumber.getOrElse(() => ""),
                                    style: const TextStyle(fontSize: 14, color: CustomColors.blueVoltz),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            const _PinPut(),
                            const SizedBox(height: 75),
                            if (model.isProcessing)
                              const SingleChildScrollView()
                            else
                              LayoutBuilder(
                                builder: (BuildContext ctx, BoxConstraints constraints){
                                  switch (model.loginScreenStatus) {
                                    case LoginScreenStatus.registerScreen:
                                      Future.delayed(const Duration(seconds: 0), () {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const RegisterView()));
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: SelectableText(
                                            "Necesitamos crear tu usuario.",
                                            style: CustomStyles.styleVolcanicDos,
                                          ),
                                          backgroundColor: CustomColors.energyYellow,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(milliseconds: 2000),
                                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                          onVisible: () async {},
                                        ));
                                      });
                                      return _ActionButton(onTap: model.validateCode,);
                                    case LoginScreenStatus.overview:
                                      Future.delayed(const Duration(seconds: 0), () {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: SelectableText(
                                            "Bienvenido.",
                                            style: CustomStyles.styleVolcanicDos,
                                          ),
                                          backgroundColor: CustomColors.energyYellow,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(milliseconds: 2000),
                                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                                          onVisible: () async {},
                                        ));
                                      });
                                      return _ActionButton(onTap: model.validateCode,);
                                    default:
                                      return _ActionButton(onTap: model.validateCode,);
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }
}


class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: "Entrar",
      onPressed: () {
        FocusScope.of(context).unfocus();
        onTap();
      },
    );
  }
}


class _PinPut extends StackedHookView<LoginViewModel> {
  const _PinPut({Key? key,}) : super(key: key);

  @override
  Widget builder(BuildContext context, LoginViewModel model) {
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