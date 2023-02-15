import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/login/register/register_view_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel()..init(),
      child: const Scaffold(
        backgroundColor: CustomColors.blueVoltz,
        body: _RegisterBody(),
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
                  "Eres nuevo",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: CustomColors.dark,
                  ),
                ),
                const SizedBox(height: 5),
                const SelectableText(
                  "Regístrate gratis y rápido.",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    color: CustomColors.dark,
                  ),
                ),
                const SizedBox(height: 7.5),
                InputText(
                  hintText: "Nombre(s)",
                  controller: context.read<RegisterViewModel>().nameController,
                  margin: const EdgeInsets.symmetric(vertical: 7.5),
                ),
                InputText(
                  hintText: "Apellidos",
                  controller: context.read<RegisterViewModel>().lastNameController,
                  margin: const EdgeInsets.symmetric(vertical: 7.5),
                ),
                InputText(
                  hintText: "Correo electronico",
                  controller: context.read<RegisterViewModel>().emailController,
                  margin: const EdgeInsets.symmetric(vertical: 7.5),
                ),

                //TODO incluir el numero de telefono
                const SizedBox(height: 21),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: CupertinoSwitch(
                        value: context.watch<RegisterViewModel>().isBusiness,
                        onChanged: (v) => context.read<RegisterViewModel>().isBusinessChanged(),
                        activeColor: CustomColors.blueVoltz,
                      ),
                    ),
                    const Expanded(child: Text("Soy una empresa")),
                  ],
                ),
                const SizedBox(height: 15),
                InputText(
                  enabled: context.watch<RegisterViewModel>().isBusiness,
                  hintText: "RFC de la empresa",
                  controller: context.read<RegisterViewModel>().rfcController,
                ),
                const SizedBox(height: 80),
                PrimaryButton(
                  text: "Registrar",
                  enabled: false,
                  onPressed: () {
                    //login button action
                    context.read<RegisterViewModel>().register();
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
