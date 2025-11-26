import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/mobsafety_header.dart';
import 'package:moby_safe/Pages/pavimentos_pista.dart';

class ClassificacaoViaPage extends StatefulWidget {
  const ClassificacaoViaPage({super.key});

  @override
  State<ClassificacaoViaPage> createState() => _ClassificacaoViaPageState();
}

class _ClassificacaoViaPageState extends State<ClassificacaoViaPage> {
  final List<String> categorias = [
    'Via Local',
    'Via Coletora',
    'Via Arterial',
    'Via de Trânsito Rápido',
  ];

  final List<String> tipos = [
    'Rua',
    'Avenida',
    'Travessa',
    'Alameda',
    'Via Coletora',
    'Via de Trânsito Rápido',
  ];

  final Set<String> selecionadasCategoria = {};
  final Set<String> selecionadasTipo = {};

  Widget _secaoCheckbox({
    required String titulo,
    required List<String> opcoes,
    required Set<String> selecionadas,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E2A43),
          ),
        ),
        const SizedBox(height: 12),
        ...opcoes.map(
          (op) => CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              op,
              style: const TextStyle(fontSize: 16),
            ),
            value: selecionadas.contains(op),
            onChanged: (v) {
              setState(() {
                if ((v ?? false) == true) {
                  selecionadas.add(op);
                } else {
                  selecionadas.remove(op);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(36),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Definição do ponto\nfinal de análise:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),

                _secaoCheckbox(
                  titulo: 'Qual a categoria da via?',
                  opcoes: categorias,
                  selecionadas: selecionadasCategoria,
                ),
                const SizedBox(height: 24),

                _secaoCheckbox(
                  titulo: 'Se trata de uma?',
                  opcoes: tipos,
                  selecionadas: selecionadasTipo,
                ),

                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PavimentosPistaRolamentoPage()),
                      );
                    },
                    child: const Text('Proxima etapa'),
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