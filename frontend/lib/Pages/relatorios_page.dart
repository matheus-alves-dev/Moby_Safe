import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/mobsafety_header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moby_safe/core/api_config.dart';
import 'package:printing/printing.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  List<Map<String, dynamic>> relatorios = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRelatorios();
  }

  Future<void> _carregarRelatorios() async {
    final baseUrl = apiBaseUrl();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final resp = await http.get(
      Uri.parse('$baseUrl/relatorios'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as List<dynamic>;
      setState(() {
        relatorios = data.cast<Map<String, dynamic>>();
        carregando = false;
      });
    } else {
      setState(() => carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao carregar (${resp.statusCode})')),
        );
      }
    }
  }

  Future<void> _baixarRelatorio(Map<String, dynamic> item) async {
    final baseUrl = apiBaseUrl();
    final id = (item['id'] ?? '').toString();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final resp = await http.get(
      Uri.parse('$baseUrl/relatorios/$id/arquivo'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    if (resp.statusCode == 200) {
      await Printing.sharePdf(bytes: resp.bodyBytes, filename: 'relatorio_$id.pdf');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao baixar (${resp.statusCode})')),
      );
    }
  }

  Widget _buildItem(Map<String, dynamic> item, int index, {bool showDividerBelow = true}) {
    final titulo = (item['titulo'] ?? 'Relatório de Inspeção') as String;
    final autor = (item['autor_nome'] ?? '-') as String;
    final numero = (index + 1).toString().padLeft(2, '0');
    return Column(
      children: [
        InkWell(
          onTap: () => _baixarRelatorio(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Text(
                  '$numero $titulo - $autor',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.download_outlined, color: Colors.black45, size: 18),
              ],
            ),
          ),
        ),
        if (showDividerBelow)
          const Divider(height: 1, color: Colors.black12),
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
            const Text('Relatórios', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: carregando
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: relatorios.length,
                        itemBuilder: (context, index) {
                          return _buildItem(
                            relatorios[index],
                            index,
                            showDividerBelow: index != relatorios.length - 1,
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
