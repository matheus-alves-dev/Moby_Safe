import 'package:flutter/material.dart';
import 'package:moby_safe_estagio/widgets/mobsafety_header.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  Widget _buildItem(String label, {bool showDividerBelow = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        if (showDividerBelow)
          const Divider(
            height: 1,
            color: Colors.black12,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // "Relatório 01 - Nome", ..., "Relatório 10 - Nome"
    final itens = List.generate(
      10,
      (i) => 'Relatório ${i + 1 < 10 ? '0${i + 1}' : '${i + 1}'} - Nome',
    );

    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // título da tela
            const Text(
              'Relatórios',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // lista rolável
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: itens.length,
                  itemBuilder: (context, index) {
                    return _buildItem(
                      itens[index],
                      showDividerBelow: index != itens.length - 1,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
