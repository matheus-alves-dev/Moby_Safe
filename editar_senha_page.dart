import 'package:flutter/material.dart';
import 'package:moby_safe_estagio/widgets/mobsafety_header.dart';

class EditarSenhaPage extends StatefulWidget {
  const EditarSenhaPage({super.key});

  @override
  State<EditarSenhaPage> createState() => _EditarSenhaPageState();
}

class _EditarSenhaPageState extends State<EditarSenhaPage> {
  final TextEditingController senhaAtualCtrl = TextEditingController();
  final TextEditingController senhaNovaCtrl = TextEditingController();
  final TextEditingController senhaNovaRepeteCtrl = TextEditingController();

  bool mostrarAtual = false;
  bool mostrarNova = false;
  bool mostrarRepete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // título da seção (padrão das telas de conta)
            const Text(
              'Dados da conta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // conteúdo rolável
            Expanded(
              child: ListView(
                children: [
                  // Senha atual
                  const Text(
                    'Informe senha atual:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: senhaAtualCtrl,
                    obscureText: !mostrarAtual,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            mostrarAtual = !mostrarAtual;
                          });
                        },
                        icon: Icon(
                          mostrarAtual
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        // aqui você poderia validar senha atual,
                        // mas por enquanto deixa vazio
                      },
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Nova senha
                  const Text(
                    'Informe nova senha:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: senhaNovaCtrl,
                    obscureText: !mostrarNova,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            mostrarNova = !mostrarNova;
                          });
                        },
                        icon: Icon(
                          mostrarNova ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Repete senha
                  const Text(
                    'Repita nova senha:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: senhaNovaRepeteCtrl,
                    obscureText: !mostrarRepete,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            mostrarRepete = !mostrarRepete;
                          });
                        },
                        icon: Icon(
                          mostrarRepete
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
