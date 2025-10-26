import 'package:flutter/material.dart';
import 'package:moby_safe_estagio/widgets/mobsafety_header.dart';

class QuemSomosPage extends StatelessWidget {
  const QuemSomosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // título da tela
            const Text(
              'Quem somos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // texto institucional rolável
            Expanded(
              child: ListView(
                children: const [
                  Text(
                    'Somos um grupo de pesquisa comprometido em transformar a '
                    'forma como a segurança viária é avaliada nas cidades. Nosso foco '
                    'principal está na inspeção de segurança viária em locais com a '
                    'presença de Polos Geradores de Viagens (PGVs) de grande porte e '
                    'demais áreas críticas do perímetro urbano, onde o fluxo intenso de '
                    'veículos e pedestres exige soluções precisas e eficazes na promoção '
                    'da segurança viária.\n\n'
                    'Acreditamos que a análise sistemática desses pontos estratégicos é '
                    'essencial para reduzir riscos, prevenir sinistros e oferecer subsídios '
                    'técnicos às decisões de planejamento urbano. Nosso propósito é unir '
                    'conhecimento acadêmico, inovação tecnológica e responsabilidade social.\n\n'
                    'O MobSafety nasceu da necessidade de criar uma ferramenta prática, '
                    'moderna e acessível para apoiar gestores, engenheiros, '
                    'planejadores urbanos e órgãos de trânsito na tomada de decisões '
                    'fundamentadas em normas, boas práticas, dados confiáveis e '
                    'critérios técnicos. A partir dessa visão, estruturamos uma ferramenta '
                    'de inspeção de segurança viária que alia rigor metodológico, '
                    'inovação digital e compromisso com a vida.\n\n'
                    'Este trabalho é fruto da dedicação conjunta de:\n'
                    'Janekelly Vilela Santos\n'
                    'Alexandre Okumura More\n'
                    'Bacus Nahime de Oliveira\n'
                    'Gustavo Martins Lima\n'
                    'Philippe Barbosa Silva',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
