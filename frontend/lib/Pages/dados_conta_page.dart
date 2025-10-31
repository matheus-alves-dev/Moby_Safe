import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/editar_nome_orgao_page.dart';

class DadosContaPage extends StatelessWidget {
  const DadosContaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados da conta'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dados da conta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Text('Nome do órgão executor:'),
              const SizedBox(height: 4),
              const Text('Prefeitura XXXX.'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditarNomeOrgaoPage(),
                    ),
                  );
                },
                child: const Text('Editar nome do órgão executor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
