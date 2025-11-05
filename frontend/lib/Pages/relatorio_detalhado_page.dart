import 'package:flutter/material.dart';
import 'package:moby_safe_estagio/services/rascunho_service.dart';
import 'package:moby_safe_estagio/widgets/mobsafety_header.dart';

/// Página de relatório detalhado, consumindo dados do RascunhoService.
/// Exibe resumo, fotos (como strings/URLs) e uma nota de "score" calculada
/// com base na presença de coordenadas e fotos.
class RelatorioDetalhadoPage extends StatefulWidget {
  final String coletaId;

  const RelatorioDetalhadoPage({super.key, required this.coletaId});

  @override
  State<RelatorioDetalhadoPage> createState() => _RelatorioDetalhadoPageState();
}

class _RelatorioDetalhadoPageState extends State<RelatorioDetalhadoPage> {
  Map<String, dynamic>? _carregarColeta(String id) {
    // ✅ método correto do RascunhoService
    return RascunhoService.instance.findById(id);
  }

  int _calcularScore(Map<String, dynamic> c) {
    final temCoord = (c['latitude'] != null && c['longitude'] != null);
    final fotos = (c['fotos'] as List?) ?? const [];
    int score = 0;
    if (temCoord) score += 50;
    score += (fotos.length * 10).clamp(0, 50);
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final coleta = _carregarColeta(widget.coletaId);

    return Scaffold(
      appBar: MobSafetyAppBar.build(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        label: const Text('X'),
        backgroundColor: const Color(0xFF0E2A43),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: coleta == null
            ? const Center(
                child: Text(
                  'Coleta não encontrada.\nRetorne à tela anterior.',
                  textAlign: TextAlign.center,
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inspeção de Segurança Viária',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Relatório Detalhado',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),

                      Text('ID da Coleta: ${coleta['id']}'),
                      Text('Criado em: ${coleta['criadoEm'] ?? '-'}'),
                      const SizedBox(height: 12),

                      const Text(
                        'Observação:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(coleta['observacao']?.toString().isEmpty ?? true
                          ? '(sem observação)'
                          : coleta['observacao']),
                      const SizedBox(height: 12),

                      Text('Latitude: ${coleta['latitude'] ?? '-'}'),
                      Text('Longitude: ${coleta['longitude'] ?? '-'}'),
                      const SizedBox(height: 12),

                      // Evidências
                      const Text(
                        'Evidências:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      if ((coleta['fotos'] as List?)?.isEmpty ?? true)
                        const Text('Nenhuma evidência adicionada.'),
                      if ((coleta['fotos'] as List?)?.isNotEmpty ?? false)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (coleta['fotos'] as List).length,
                          itemBuilder: (_, i) {
                            final fotos = coleta['fotos'] as List;
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.image_outlined),
                              title: Text(fotos[i].toString()),
                            );
                          },
                        ),

                      const SizedBox(height: 16),
                      // Score calculado
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Score de Evidências:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${_calcularScore(coleta)}/100',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: () {
                            RascunhoService.instance
                                .removerColeta(widget.coletaId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Rascunho removido.')),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Excluir Rascunho'),
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
