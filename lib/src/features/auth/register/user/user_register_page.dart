import 'package:agenda_barber/src/core/ui/helpers/form_helper.dart';
import 'package:agenda_barber/src/core/ui/helpers/messages.dart';
import 'package:agenda_barber/src/features/auth/register/user/user_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRegisterVM = ref.watch(userRegisterVMProvider.notifier);

    ref.listen(userRegisterVMProvider, (_, state) {
      switch (state) {
        case UserRegisterStatus.initial:
          break;
        case UserRegisterStatus.success:
          Navigator.of(context).pushNamed('/auth/register/barbershop');
        case UserRegisterStatus.error:
          Messages.showError(
            'Erro ao registrar usuãrio Administrador',
            context,
          );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  controller: nameEC,
                  validator: Validatorless.required('Nome obrigatõrio'),
                  decoration: InputDecoration(label: Text('Nome')),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  controller: emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatõrio'),
                    Validatorless.email('E-mail invãlido'),
                  ]),
                  decoration: InputDecoration(label: Text('E-mail')),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  controller: passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatoria'),
                    Validatorless.min(
                      6,
                      'A senha deve ter no mínimo 6 caracteres',
                    ),
                  ]),
                  obscureText: true,
                  decoration: InputDecoration(label: Text('Senha')),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirmar senha obrigatoria'),
                    Validatorless.min(
                      6,
                      'A senha deve ter no mínimo 6 caracteres',
                    ),
                    Validatorless.compare(
                      passwordEC,
                      'Senhas não correspondem',
                    ),
                  ]),
                  decoration: InputDecoration(label: Text('Confirmar senha')),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () async {
                    switch (formKey.currentState?.validate()) {
                      case null || false:
                        Messages.showError('Formulário inválido', context);
                      case true:
                        await userRegisterVM.register(
                          name: nameEC.text,
                          email: emailEC.text,
                          password: passwordEC.text,
                        );
                    }
                  },
                  child: Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
