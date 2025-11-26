import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/mobsafety_header.dart';
import 'package:moby_safe/Pages/analise_final.dart' as finalpg;

class PontoInicialPage extends StatefulWidget {
  const PontoInicialPage({super.key});

  @override
  State<PontoInicialPage> createState() => _PontoInicialPageState();
}

class _PontoInicialPageState extends State<PontoInicialPage> {
  String coordInicio = 'Ex: -17.78XXXX, -50.96XXXX';
  String pontoReferencia = 'XXX';

  Future<void> _editarTexto({
    required String titulo,
    required String valorAtual,
    required ValueChanged<String> onSave,
  }) async {
    if (!mounted) return;
    final ctrl = TextEditingController(text: valorAtual);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: ctrl,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              onSave(ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
  }

  Widget _editButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _item({
    required String label,
    required String value,
    required VoidCallback onEdit,
    IconData icon = Icons.edit_outlined,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E2A43),
                ),
              ),
            ),
            _editButton(icon, onEdit),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
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
                  'Definição do ponto\ninicial de análise:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),

                _item(
                  label: 'Coordenadas geográficas (início):',
                  value: coordInicio,
                  onEdit: () {
                    _editarTexto(
                      titulo: 'Coordenadas geográficas (início)',
                      valorAtual: coordInicio,
                      onSave: (v) {
                        if (v.isNotEmpty) setState(() => coordInicio = v);
                      },
                    );
                  },
                  icon: Icons.edit_outlined,
                ),
                const SizedBox(height: 24),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Localização do ponto inicial:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0E2A43),
                        ),
                      ),
                    ),
                    _editButton(Icons.location_on_outlined, () {}),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'gps_app.png',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stack) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.black26,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _item(
                  label: 'Ponto de referência:',
                  value: pontoReferencia,
                  onEdit: () {
                    _editarTexto(
                      titulo: 'Ponto de referência',
                      valorAtual: pontoReferencia,
                      onSave: (v) {
                        if (v.isNotEmpty) setState(() => pontoReferencia = v);
                      },
                    );
                  },
                  icon: Icons.edit_outlined,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const finalpg.PontoInicialPage()),
                      );
                    },
                    child: const Text('Ir para análise final'),
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