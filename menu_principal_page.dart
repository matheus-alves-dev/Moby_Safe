import 'package:flutter/material.dart';
import 'package:moby_safe_estagio/pages/relatorios_page.dart';
import 'package:moby_safe_estagio/pages/dados_conta_page.dart';
import 'package:moby_safe_estagio/pages/quem_somos_page.dart';
import 'package:moby_safe_estagio/pages/login_page.dart';
import 'package:moby_safe_estagio/widgets/mobsafety_header.dart';
// futuramente: import 'package:moby_safe_estagio/pages/novo_questionario_page.dart';

class MenuPrincipalPage extends StatelessWidget {
  const MenuPrincipalPage({super.key});

  Widget _buildMenuRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool danger = false,
    bool showDividerBelow = true,
    bool showChevron = true,
  }) {
    final baseColor = danger ? Colors.red : Colors.black;
    final textStyle = TextStyle(
      fontSize: 16,
      fontWeight: danger ? FontWeight.w600 : FontWeight.w500,
      color: baseColor,
    );

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: danger ? Colors.red : Colors.black87,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: textStyle,
                  ),
                ),
                if (!danger && showChevron)
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.black38,
                  ),
              ],
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
    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TÍTULO DA TELA (agora é só um título, como você pediu)
            const Text(
              'Menu principal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // BLOCO DE OPÇÕES
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
                child: ListView(
                  children: [
                    // Novo Questionário
                    _buildMenuRow(
                      context: context,
                      icon: Icons.playlist_add_check_rounded,
                      label: 'Novo Questionário',
                      onTap: () {
                        // TODO: implementar rota
                        // Navigator.push(context,
                        //   MaterialPageRoute(builder: (_) => const NovoQuestionarioPage()),
                        // );
                      },
                    ),

                    // Relatórios
                    _buildMenuRow(
                      context: context,
                      icon: Icons.insert_drive_file_rounded,
                      label: 'Relatórios',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RelatoriosPage(),
                          ),
                        );
                      },
                    ),

                    // Dados da conta
                    _buildMenuRow(
                      context: context,
                      icon: Icons.account_circle_rounded,
                      label: 'Dados da conta',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DadosContaPage(),
                          ),
                        );
                      },
                    ),

                    // Quem somos
                    _buildMenuRow(
                      context: context,
                      icon: Icons.info_rounded,
                      label: 'Quem somos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuemSomosPage(),
                          ),
                        );
                      },
                    ),

                    // SAIR (você pode remover essa linha da home se quiser deixar só no menu ⋮)
                    _buildMenuRow(
                      context: context,
                      icon: Icons.logout_rounded,
                      label: 'SAIR',
                      danger: true,
                      showDividerBelow: false,
                      showChevron: false,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
