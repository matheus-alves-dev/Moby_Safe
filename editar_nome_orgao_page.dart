import 'package:flutter/material.dart';
import 'package:moby_safe_estagio/widgets/mobsafety_header.dart';

class EditarNomeOrgaoPage extends StatefulWidget {
  const EditarNomeOrgaoPage({super.key});

  @override
  State<EditarNomeOrgaoPage> createState() => _EditarNomeOrgaoPageState();
}

class _EditarNomeOrgaoPageState extends State<EditarNomeOrgaoPage> {
  final TextEditingController novoNomeCtrl =
      TextEditingController(text: 'Prefeitura XXXX.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da seção (igual padrão de todas as telas de conta)
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
                  const Text(
                    'Novo nome do órgão executor:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: novoNomeCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Novo nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        // futuro: enviar alteração pro backend
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Salvar alterações',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
