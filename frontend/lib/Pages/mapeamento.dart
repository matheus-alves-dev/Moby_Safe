import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/mobsafety_header.dart';

class MapeamentoPage extends StatefulWidget {
  const MapeamentoPage({super.key});

  @override
  State<MapeamentoPage> createState() => _MapeamentoPageState();
}

class _MapeamentoPageState extends State<MapeamentoPage> {
  DateTime? dataInspecao;
  String auditorNome = 'Fulano de tal';
  String nomeDaVia = 'Ex: Rua ....';
  String extensaoTrecho = 'XXX metros';

  String _formatDate(DateTime? d) {
    if (d == null) return '__ / __ / ____';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd / $mm / $yyyy';
  }

  Future<void> _editarData() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: dataInspecao ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => dataInspecao = picked);
    }
  }

  Future<void> _editarTexto({
    required String titulo,
    required String valorAtual,
    required ValueChanged<String> onSave,
  }) async {
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

  Widget _editButton(VoidCallback onTap) {
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
        child: const Icon(
          Icons.edit_outlined,
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
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E2A43), // azul escuro
                ),
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
          ),
        ),
        const SizedBox(width: 12),
        _editButton(onEdit),
      ],
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
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
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Center(
                        child: FlutterLogo(size: 36), // placeholder do logo
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Mapeamento',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _item(
                  label: 'Data da inspeção:',
                  value: _formatDate(dataInspecao),
                  onEdit: _editarData,
                ),
                const SizedBox(height: 24),

                _item(
                  label: 'Nome do auditor(a):',
                  value: auditorNome,
                  onEdit: () {
                    _editarTexto(
                      titulo: 'Nome do auditor(a)',
                      valorAtual: auditorNome,
                      onSave: (v) {
                        if (v.isNotEmpty) setState(() => auditorNome = v);
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                _item(
                  label: 'Nome da via:',
                  value: nomeDaVia,
                  onEdit: () {
                    _editarTexto(
                      titulo: 'Nome da via',
                      valorAtual: nomeDaVia,
                      onSave: (v) {
                        if (v.isNotEmpty) setState(() => nomeDaVia = v);
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                _item(
                  label: 'Extensão do trecho analisado:',
                  value: extensaoTrecho,
                  onEdit: () {
                    _editarTexto(
                      titulo: 'Extensão do trecho analisado',
                      valorAtual: extensaoTrecho,
                      onSave: (v) {
                        if (v.isNotEmpty) setState(() => extensaoTrecho = v);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}