// lib/pages/finalizar_inspecao_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moby_safe/Pages/mobsafety_header.dart';
import 'package:moby_safe/services/rascunho_service.dart';
import 'package:moby_safe/widgets/mobsafety_header.dart';

class FinalizarInspecaoPage extends StatefulWidget {
  const FinalizarInspecaoPage({super.key});

  @override
  State<FinalizarInspecaoPage> createState() => _FinalizarInspecaoPageState();
}

class _FinalizarInspecaoPageState extends State<FinalizarInspecaoPage> {
  final TextEditingController _obsFinalCtrl = TextEditingController();

  @override
  void dispose() {
    _obsFinalCtrl.dispose();
    super.dispose();
  }

  void _gerarResumoJson() {
    final List<Map<String, dynamic>> coletas = RascunhoService.instance.coletas;

    // ✅ garante int no acumulador
    final int totalEvidencias = coletas.fold<int>(
      0,
      (int sum, Map<String, dynamic> c) {
        final List fotos = (c['fotos'] as List?) ?? const [];
        return sum + fotos.length;
      },
    );

    final Map<String, dynamic> resumo = <String, dynamic>{
      'totalColetas': coletas.length,
      'totalEvidencias': totalEvidencias,
      'observacaoFinal': _obsFinalCtrl.text.trim(),
      'dataGeracao': DateTime.now().toIso8601String(),
      'coletas': coletas,
    };

    final String texto = const JsonEncoder.withIndent('  ').convert(resumo);
    Clipboard.setData(ClipboardData(text: texto));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resumo copiado em JSON.')),
    );
  }

  void _enviarInspecao() {
    final coletas = RascunhoService.instance.coletas;
    if (coletas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma coleta registrada.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar envio'),
        content: const Text(
          'Deseja realmente finalizar e enviar esta inspeção? '
          'As coletas locais serão apagadas após o envio.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              RascunhoService.instance.limparColetas();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Inspeção enviada com sucesso.')),
              );
              Navigator.pop(context);
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> coletas = RascunhoService.instance.coletas;

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
        child: SingleChildScrollView(
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Finalizar Inspeção',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                if (coletas.isEmpty)
                  const Text(
                    'Nenhuma coleta salva. Retorne à tela de Coleta de Dados.',
                    style: TextStyle(color: Colors.grey),
                  ),
                if (coletas.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: coletas.length,
                    itemBuilder: (_, i) {
                      final c = coletas[i];
                      final List fotos = (c['fotos'] as List?) ?? const [];
                      return ListTile(
                        leading: const Icon(Icons.place_outlined),
                        title: Text(
                          'Coleta ${c['id']}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Lat: ${c['latitude'] ?? '-'} | Lng: ${c['longitude'] ?? '-'} | '
                          'Fotos: ${fotos.length}',
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Observação Final / Considerações',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _obsFinalCtrl,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText:
                        'Adicione considerações finais sobre a inspeção...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _enviarInspecao,
                    child: const Text('Enviar Inspeção'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _gerarResumoJson,
                    icon: const Icon(Icons.copy),
                    label: const Text('Gerar resumo em JSON'),
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
