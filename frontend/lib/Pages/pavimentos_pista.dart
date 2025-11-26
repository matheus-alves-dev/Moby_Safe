import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/mobsafety_header.dart';
import 'package:printing/printing.dart';
import 'package:moby_safe/services/relatorio_pdf_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Question {
  final String code;
  final String section;
  final String? subsection;
  final String text;
  final List<String> options;
  Question({
    required this.code,
    required this.section,
    this.subsection,
    required this.text,
    required this.options,
  });
}

class PavimentosPistaRolamentoPage extends StatefulWidget {
  const PavimentosPistaRolamentoPage({super.key});

  @override
  State<PavimentosPistaRolamentoPage> createState() => _PavimentosPistaRolamentoPageState();
}

class _PavimentosPistaRolamentoPageState extends State<PavimentosPistaRolamentoPage> {
  final List<Question> questions = [
    Question(
      code: '1.1',
      section: 'Pavimentos',
      subsection: 'Pista de Rolamento',
      text: 'Qual a largura da pista de rolamento?',
      options: ['< 2,70m', 'entre 2,70m e 2,90m', 'entre 3,00m e 3,20m', 'entre 3,30m e 3,50m', '> 3,50m'],
    ),
    Question(
      code: '1.2',
      section: 'Pavimentos',
      subsection: 'Pista de Rolamento',
      text: 'O pavimento apresenta buracos, obstruções, abaulamentos ou outros danos?',
      options: ['Sim', 'Não'],
    ),
    Question(
      code: '1.3',
      section: 'Calçadas',
      subsection: null,
      text: 'Existe calçada em todas as áreas destinadas a passeio de pedestres?',
      options: ['Sim', 'Não'],
    ),
    Question(
      code: '1.4',
      section: 'Calçadas',
      subsection: null,
      text: 'Qual a largura das calçadas?',
      options: ['< 1,20m', 'entre 1,20m e 1,50m', 'entre 1,50m e 1,80m', '> 1,80m'],
    ),
    Question(
      code: '1.5',
      section: 'Calçadas',
      subsection: null,
      text: 'O passeio apresenta buracos, degraus ou outros obstáculos que comprometam a caminhabilidade?',
      options: ['Sim', 'Não'],
    ),
    Question(
      code: '1.6',
      section: 'Ciclovia ou ciclofaixa',
      subsection: null,
      text: 'A via possui infraestrutura adequada para ciclistas (ciclovia ou ciclofaixa) em condições de uso seguro?',
      options: ['Sim', 'Não'],
    ),
    Question(code: '2.1', section: 'Sinalização viária', subsection: 'Vertical', text: 'As placas estão visíveis e legíveis?', options: ['Sim', 'Não']),
    Question(code: '2.2', section: 'Sinalização viária', subsection: 'Vertical', text: 'Estão em bom estado de conservação?', options: ['Sim', 'Não']),
    Question(code: '2.3', section: 'Sinalização viária', subsection: 'Vertical', text: 'Estão instaladas conforme a norma (altura, posição, retrorefletividade)?', options: ['Sim', 'Não']),
    Question(code: '2.4', section: 'Sinalização viária', subsection: 'Horizontal', text: 'A pintura horizontal é visível e legível?', options: ['Sim', 'Não']),
    Question(code: '2.5', section: 'Sinalização viária', subsection: 'Horizontal', text: 'A sinalização horizontal atende aos padrões de cores e dimensões normativas?', options: ['Sim', 'Não']),
    Question(code: '2.6', section: 'Sinalização viária', subsection: 'Dispositivos de moderação de tráfego', text: 'Existem dispositivos de moderação (lombadas, travessias elevadas, estreitamentos)?', options: ['Sim', 'Não']),
    Question(code: '2.7', section: 'Sinalização viária', subsection: 'Dispositivos de moderação de tráfego', text: 'Estão sinalizados adequadamente?', options: ['Sim', 'Não']),
    Question(code: '2.8', section: 'Sinalização viária', subsection: 'Dispositivos de moderação de tráfego', text: 'São suficientes e eficazes para reduzir a velocidade?', options: ['Sim', 'Não']),
    Question(code: '2.9', section: 'Sinalização viária', subsection: 'Complementar', text: 'Existe semáforo no cruzamento?', options: ['Sim', 'Não']),
    Question(code: '2.10', section: 'Sinalização viária', subsection: 'Complementar', text: 'O tempo semafórico é adequado?', options: ['Sim', 'Não']),
    Question(code: '2.11', section: 'Sinalização viária', subsection: 'Complementar', text: 'Há dispositivos sonoros/visuais para acessibilidade?', options: ['Sim', 'Não']),
    Question(code: '3.1', section: 'Pedestres', subsection: null, text: 'Existem travessias seguras e acessíveis para pedestres e ciclistas?', options: ['Sim', 'Não']),
    Question(code: '3.2', section: 'Pedestres', subsection: null, text: 'Os pedestres e ciclistas conseguem atravessar em tempo hábil?', options: ['Sim', 'Não']),
    Question(code: '4.1', section: 'Visibilidade', subsection: 'Interseções', text: 'O motorista possui visibilidade adequada para cruzar a via?', options: ['Sim', 'Não']),
    Question(code: '4.2', section: 'Visibilidade', subsection: 'Obstruções no entorno', text: 'Há árvores, postes, mobiliário urbano ou construções que obstruem a visão de pedestres e motoristas?', options: ['Sim', 'Não']),
    Question(code: '5.1', section: 'Veículos motorizados e manobras', subsection: 'Velocidade e operação', text: 'A velocidade permitida está claramente sinalizada?', options: ['Sim', 'Não']),
    Question(code: '5.2', section: 'Veículos motorizados e manobras', subsection: 'Velocidade e operação', text: 'As conversões podem ser realizadas sem invadir faixas adjacentes?', options: ['Sim', 'Não']),
    Question(code: '6.1', section: 'Mobilidade urbana', subsection: 'Estacionamento', text: 'Existem vagas de estacionamento?', options: ['Sim', 'Não']),
    Question(code: '6.2', section: 'Mobilidade urbana', subsection: 'Estacionamento', text: 'São suficientes e bem localizadas?', options: ['Sim', 'Não']),
    Question(code: '7.1', section: 'Ônibus', subsection: null, text: 'Existem pontos de ônibus próximos ao PGV?', options: ['Sim', 'Não']),
    Question(code: '7.2', section: 'Ônibus', subsection: null, text: 'Possuem abrigo, iluminação e acessibilidade?', options: ['Sim', 'Não']),
    Question(code: '7.3', section: 'Ônibus', subsection: null, text: 'O embarque/desembarque compromete o fluxo da via?', options: ['Sim', 'Não']),
    Question(code: '8.4', section: 'Acessibilidade', subsection: null, text: 'As calçadas atendem à NBR 9050/2015 (acessibilidade)?', options: ['Sim', 'Não']),
    Question(code: '9.1', section: 'Comportamentos de Risco', subsection: 'Condutores Distrações', text: 'Há motoristas utilizando celular ou dispositivos eletrônicos durante a condução?', options: ['Sim', 'Não']),
    Question(code: '9.2', section: 'Comportamentos de Risco', subsection: 'Condutores Respeito às regras', text: 'Os motoristas respeitam as regras de trânsito?', options: ['Sim', 'Não']),
    Question(code: '9.3', section: 'Comportamentos de Risco', subsection: 'Condutores Respeito às regras', text: 'Há indícios de excesso de velocidade visível?', options: ['Sim', 'Não']),
    Question(code: '9.4', section: 'Comportamentos de Risco', subsection: 'Condutores Convivência', text: 'Os motoristas respeitam a prioridade de pedestres e ciclistas nas travessias?', options: ['Sim', 'Não']),
    Question(code: '9.5', section: 'Comportamentos de Risco', subsection: 'Condutores Convivência', text: 'As ultrapassagens e mudanças de faixa são realizadas de forma segura?', options: ['Sim', 'Não']),
    Question(code: '9.6', section: 'Comportamentos de Risco', subsection: 'Pedestres', text: 'Os pedestres utilizam as faixas de travessia disponíveis?', options: ['Sim', 'Não']),
    Question(code: '9.7', section: 'Comportamentos de Risco', subsection: 'Pedestres', text: 'Há travessias irregulares frequentes (jaywalking)?', options: ['Sim', 'Não']),
    Question(code: '9.8', section: 'Comportamentos de Risco', subsection: 'Ciclistas', text: 'Os ciclistas circulam prioritariamente em ciclovias/ciclofaixas quando disponíveis?', options: ['Sim', 'Não']),
    Question(code: '9.9', section: 'Comportamentos de Risco', subsection: 'Ciclistas', text: 'Há ciclistas circulando na contramão ou em áreas destinadas a pedestres?', options: ['Sim', 'Não']),
    Question(code: '10.1', section: 'PGVs', subsection: 'Triagem', text: 'Há PGV com demanda significativa que influencia no tráfego e mobilidade urbana?', options: ['Sim', 'Não']),
    Question(code: '10.2', section: 'PGVs', subsection: 'Conflitos com pedestres', text: 'Existe fluxo intenso de pedestres para acessar o PGV e travessias seguras e sinalizadas próximas ao acesso?', options: ['Sim', 'Não']),
    Question(code: '10.3', section: 'PGVs', subsection: 'Carga e descarga', text: 'O local possui área destinada a carga e descarga segregada da circulação principal?', options: ['Sim', 'Não']),
    Question(code: '10.4', section: 'PGVs', subsection: 'Fluxo e picos', text: 'Há horários de pico associados ao funcionamento do PGV que impactam diretamente a via?', options: ['Sim', 'Não']),
    Question(code: '10.5', section: 'PGVs', subsection: 'Estacionamento', text: 'O estacionamento do PGV é suficiente ou gera ocupação irregular das vias próximas?', options: ['Suficiente', 'Gera ocupação irregular']),
  ];

  final Map<int, int> respostas = {};
  int current = 0;

  String _sectionNumber(String code) => code.split('.').first;

  Future<void> _exportarPdf() async {
    final itens = <Map<String, String>>[];
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final rIndex = respostas[i] ?? -1;
      final resposta = rIndex >= 0 && rIndex < q.options.length ? q.options[rIndex] : '-';
      itens.add({
        'codigo': q.code,
        'secao': q.section,
        'subsecao': q.subsection ?? '',
        'pergunta': q.text,
        'resposta': resposta,
      });
    }
    final prefs = await SharedPreferences.getInstance();
    final autorNome = prefs.getString('auditor_nome');
    final bytes = await RelatorioPdfService.gerarPdf(itens, autorNome: autorNome);
    await Printing.sharePdf(bytes: bytes, filename: 'relatorio_mobsafety.pdf');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Relatório PDF gerado')));
      Navigator.pop(context);
    }
  }

  Widget _opcao(String texto, int index) {
    final ativo = respostas[current] == index;
    return InkWell(
      onTap: () => setState(() => respostas[current] = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: ativo ? const Color(0xFF7CC3E1) : Colors.white),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Center(child: Text(texto, style: const TextStyle(fontSize: 16))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[current];
    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CC3E1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(_sectionNumber(q.code), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    q.subsection == null ? q.section : '${q.section} - ${q.subsection}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0E2A43)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E2A43),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(36),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(color: const Color(0xFF132B44), borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        '${q.code}. ${q.text}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < q.options.length; i++) _opcao(q.options[i], i),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: current == 0
                                ? () => Navigator.pop(context)
                                : () => setState(() => current -= 1),
                            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF7CC3E1)),
                            child: const Text('Pergunta ← Anterior'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: respostas.containsKey(current)
                                ? () async {
                                    if (current < questions.length - 1) {
                                      setState(() => current += 1);
                                    } else {
                                      await _exportarPdf();
                                    }
                                  }
                                : null,
                            child: Text(current < questions.length - 1 ? 'Próxima Pergunta →' : 'Concluir'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.description_outlined, color: Colors.white70),
                        label: const Text('RECOMENDAÇÕES', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(child: Image.asset('logo_mobi_safe.png', height: 40)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}