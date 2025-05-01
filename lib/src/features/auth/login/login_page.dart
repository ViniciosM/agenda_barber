import 'package:agenda_barber/src/core/ui/constants.dart';
import 'package:agenda_barber/src/core/ui/helpers/form_helper.dart';
import 'package:agenda_barber/src/core/ui/helpers/messages.dart';
import 'package:agenda_barber/src/features/auth/login/login_state.dart';
import 'package:agenda_barber/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginVM(:login) = ref.watch(loginVMProvider.notifier);

    ref.listen(loginVMProvider, (_, state) {
      switch (state) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showError(errorMessage, context);
          Messages.showError('Erro ao realizar login', context);
        case LoginState(status: LoginStateStatus.error):
          Messages.showError('Erro ao realizar login', context);
        case LoginState(status: LoginStateStatus.admLogin):
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home/adm', (route) => false);
          break;
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home/employee', (route) => false);
          break;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_image_chair.jpg"),
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageConstants.imageLogo),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailEC,
                            onTapOutside: (_) => context.unfocus(),
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail obrigatório'),
                              Validatorless.email('E-mail invãlido'),
                            ]),
                            decoration: InputDecoration(
                              label: Text('Email'),
                              hintText: 'E-mail',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _passwordEC,
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha obrigatória'),
                              Validatorless.min(
                                6,
                                'Senha deve conter pelo menos 6 caracteres',
                              ),
                            ]),
                            onTapOutside: (event) => context.unfocus(),
                            obscureText: true,
                            decoration: InputDecoration(
                              label: Text('Senha'),
                              hintText: 'Senha',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: ColorsConstants.brow,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              switch (formKey.currentState?.validate()) {
                                case (false || null):
                                  Messages.showError(
                                    'Campos inválidos',
                                    context,
                                  );
                                  break;
                                case true:
                                  login(_emailEC.text, _passwordEC.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(56),
                            ),
                            child: Text('Acessar'),
                          ),
                        ],
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed('/auth/register/user');
                          },
                          child: Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
