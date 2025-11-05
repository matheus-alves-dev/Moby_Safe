import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moby_safe_estagio/widgets/mobsafety_header.dart';
import 'package:moby_safe_estagio/pages/relatorio_detalhado_page.dart';
import 'package:moby_safe_estagio/services/rascunho_service.dart';

/// Página para registrar coletas pontuais durante a inspeção.
/// Não usa plugins externos; as "fotos" são simuladas como URLs/textos
/// e os dados ficam salvos em memória via [RascunhoService].
class ColetaDadosPage extends StatefulWidget {
  const ColetaDadosPage({super.key});

  @override
  State<ColetaDadosPage> createState() => _ColetaDadosPageState();
}

class _ColetaDadosPageState extends State<ColetaDadosPage> {
  final TextEditingController _obsCtrl = TextEditingController();
  final TextEditingController _fotoCtrl = TextEditingController();
  final TextEditingController _latCtrl = TextEditingController();
  final TextEditingController _lngCtrl = TextEditingController();

  final List<String> _fotos = <String>[];

  @override
  void dispose() {
    _obsCtrl.dispose();
    _fotoCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  void _adicionarFoto() {
    final v = _fotoCtrl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      _fotos.add(v);
      _fotoCtrl.clear();
    });
  }

  void _removerFoto(int i) {
    setState(() {
      _fotos.removeAt(i);
    });
  }

  void _salvarColeta() {
    final String obs = _obsCtrl.text.trim();
    final double? lat = double.tryParse(_latCtrl.text.trim());
    final double? lng = double.tryParse(_lngCtrl.text.trim());

    // TIPAGEM FORTE: Map<String, dynamic>
    final Map<String, dynamic> coleta = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // String
      'observacao': obs,
      'latitude': lat,
      'longitude': lng,
      'fotos': List<String>.from(_fotos),
      'criadoEm': DateTime.now().toIso8601String(),
    };

    RascunhoService.instance.adicionarColeta(coleta);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coleta salva localmente (rascunho).')),
    );

    // Abre o relatório em seguida para revisão (garante String)
    final String coletaId = (coleta['id'] ?? '').toString();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RelatorioDetalhadoPage(coletaId: coletaId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Coleta de Dados',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),

                // Observação
                const Text(
                  'Observação / Nota Técnica',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _obsCtrl,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Descreva condições observadas...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Coordenadas
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _latCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\.\-]'))
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _lngCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\.\-]'))
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Fotos (como URLs/descrições)
                const Text(
                  'Evidências (URLs ou identificadores de foto)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _fotoCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Ex.: https://... ou IMG_0001',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _adicionarFoto,
                        child: const Text('Adicionar'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_fotos.isEmpty)
                  const Text('Nenhuma evidência adicionada ainda.'),
                if (_fotos.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _fotos.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(_fotos[i]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removerFoto(i),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _salvarColeta,
                    child: const Text('Salvar Coleta'),
                  ),
                ),

                const SizedBox(height: 12),
                // Utilitário: copiar JSON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final Map<String, dynamic> preview = <String, dynamic>{
                        'observacao': _obsCtrl.text.trim(),
                        'latitude': _latCtrl.text.trim(),
                        'longitude': _lngCtrl.text.trim(),
                        'fotos': List<String>.from(_fotos),
                      };
                      Clipboard.setData(
                        ClipboardData(
                          text: const JsonEncoder.withIndent('  ')
                              .convert(preview),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Prévia copiada em JSON.')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar prévia em JSON'),
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
