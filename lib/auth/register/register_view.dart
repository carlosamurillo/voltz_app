import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/auth/login/login_view.dart';
import 'package:maketplace/auth/register/register_view_model.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key, required this.phoneNumber, this.quoteId}) : super(key: key);
  final String phoneNumber;
  final String? quoteId;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel()..init(phoneNumber, quoteId),
      child: Scaffold(
        backgroundColor: AppKeys().customColors!.blueVoltz,
        body: const _RegisterBody(),
      ),
    );
  }
}

class _RegisterBody extends StatelessWidget {
  const _RegisterBody({Key? key}) : super(key: key);

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
            child: Form(
              autovalidateMode: context.watch<RegisterViewModel>().showErrorMessages ? AutovalidateMode.always : AutovalidateMode.disabled,
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
                        onPressed: () {
                          context.read<RegisterViewModel>().signOut();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  SelectableText(
                    "Eres nuevo",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppKeys().customColors!.dark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SelectableText(
                    "Regístrate gratis y rápido.",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32.0,
                      color: AppKeys().customColors!.dark,
                    ),
                  ),
                  const SizedBox(height: 7.5),
                  InputText(
                    hintText: "Nombre(s)",
                    margin: const EdgeInsets.symmetric(vertical: 7.5),
                    validator: (_) => context.watch<RegisterViewModel>().nameOption.fold(
                          (f) => "Ingrese un nombre correcto",
                          (_) => null,
                        ),
                    onChanged: (v) => context.read<RegisterViewModel>().changeName(v),
                  ),
                  InputText(
                    hintText: "Apellidos",
                    margin: const EdgeInsets.symmetric(vertical: 7.5),
                    validator: (_) => context.watch<RegisterViewModel>().lastNameOption.fold(
                          (f) => "Ingrese un apellido correcto",
                          (_) => null,
                        ),
                    onChanged: (v) => context.read<RegisterViewModel>().changeLastName(v),
                  ),
                  InputText(
                    hintText: "Correo electronico",
                    margin: const EdgeInsets.symmetric(vertical: 7.5),
                    validator: (_) => context.watch<RegisterViewModel>().emailOption.fold(
                          (f) => "El formato ingresado es incorrecto",
                          (_) => null,
                        ),
                    onChanged: (v) => context.read<RegisterViewModel>().changeEmailAddress(v),
                  ),
                  InputText(
                    hintText: "Número teléfono",
                    margin: const EdgeInsets.symmetric(vertical: 7.5),
                    enabled: false,
                    initialValue: "(+52) ${context.read<RegisterViewModel>().phoneNumber}",
                    suffixIcon: SizedBox(
                      width: 115,
                      child: ThirdButton(
                        onPressed: () {
                          context.read<RegisterViewModel>().signOut();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const LoginView()));
                        },
                        text: "Cambiar",
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: CupertinoSwitch(
                          value: context.watch<RegisterViewModel>().isBusiness,
                          onChanged: (v) => context.read<RegisterViewModel>().isBusinessChanged(),
                          activeColor: AppKeys().customColors!.blueVoltz,
                        ),
                      ),
                      const Expanded(child: Text("Soy una empresa")),
                    ],
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    enabled: context.watch<RegisterViewModel>().isBusiness,
                    hintText: "RFC de la empresa",
                    validator: (_) => context.watch<RegisterViewModel>().isBusiness
                        ? context.watch<RegisterViewModel>().rfcOption.fold(
                              (f) => "El formato ingresado es incorrecto",
                              (_) => null,
                            )
                        : null,
                    onChanged: (v) => context.read<RegisterViewModel>().changeRfc(v),
                  ),
                  const SizedBox(height: 80),
                  LayoutBuilder(
                    builder: (BuildContext ctx, BoxConstraints constraints) {
                      switch (context.read<RegisterViewModel>().registerStatus) {
                        case RegisterStatus.initial:
                          return const _ActionButton();
                        case RegisterStatus.processing:
                          return const Center(child: CircularProgressIndicator());
                        case RegisterStatus.success:
                          Future.delayed(const Duration(seconds: 0), () {
                            //
                            context.read<RegisterViewModel>().navigateToSuccessRegister();
                            //
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: SelectableText(
                                "Su usuario ha sido creado correctamente.",
                                style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
                              ),
                              backgroundColor: AppKeys().customColors!.energyGreen,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(milliseconds: 2000),
                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
                              onVisible: () async {},
                            ));
                          });
                          return const Center(child: CircularProgressIndicator());
                        case RegisterStatus.failure:
                          Future.delayed(const Duration(seconds: 0), () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: SelectableText(
                                "Ha ocurrido un error, vuelve a intentarlo.",
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
                      }
                    },
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: "Registrar",
      enabled: context.watch<RegisterViewModel>().isValidForm,
      onPressed: () {
        FocusScope.of(context).unfocus();
        context.read<RegisterViewModel>().register();
      },
    );
  }
}
