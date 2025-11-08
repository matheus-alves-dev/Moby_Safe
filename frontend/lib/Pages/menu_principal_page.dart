import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/relatorios_page.dart';
import 'package:moby_safe/Pages/dados_conta_page.dart';
import 'package:moby_safe/Pages/quem_somos_page.dart';
import 'package:moby_safe/Pages/login_page.dart';
import 'package:moby_safe/Pages/mobsafety_header.dart';
import 'package:moby_safe/Pages/mapeamento.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: _MenuHeaderClipper(),

                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: const Color(0xFF122747), // azul do cabeçalho
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('logo_mobi_safe.png', height: 50),
                      const Text(
                        'MobSafety',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Inspeção de Segurança Viária',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _menuButton(
                      icon: Icons.add_circle,
                      label: 'Novo Questionário',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MapeamentoPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _menuButton(
                      icon: Icons.article,
                      label: 'Relatórios',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RelatoriosPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _menuButton(
                      icon: Icons.settings,
                      label: 'Dados da conta',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DadosContaPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _menuButton(
                      icon: Icons.info,
                      label: 'Quem somos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuemSomosPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Substitua o texto estático por um botão com ação:
                    TextButton(
                      onPressed: () => _logout(context),
                      child: const Text(
                        'SAIR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF122747),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9), // cinza dos cards
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF122747),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A3342),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.9,
      size.width,
      size.height * 0.58,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


void _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginPage()),
    (route) => false,
  );
}
