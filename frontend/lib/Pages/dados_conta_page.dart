import 'package:flutter/material.dart';
import 'package:moby_safe/Pages/editar_nome_orgao_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moby_safe/core/api_config.dart';

class DadosContaPage extends StatefulWidget {
  const DadosContaPage({super.key});

  @override
  State<DadosContaPage> createState() => _DadosContaPageState();
}

class _DadosContaPageState extends State<DadosContaPage> {
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController telefoneCtrl = TextEditingController();
  int? orgaoId;
  String? orgaoNome;
  List<Map<String, dynamic>> orgaos = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        setState(() {
          erro = 'Sessão expirada. Faça login novamente.';
          carregando = false;
        });
        return;
      }

      final baseUrl = apiBaseUrl();
      final resp = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (resp.statusCode == 200) {
        final p = jsonDecode(resp.body) as Map<String, dynamic>;
        nomeCtrl.text = p['nome'] ?? '';
        emailCtrl.text = p['email'] ?? '';
        telefoneCtrl.text = (p['telefone'] ?? '') as String;
        orgaoId = p['id_orgao_executor'] as int?;
        orgaoNome = p['orgao_executor_nome'] as String?;
        await _carregarOrgaos();
        setState(() {
          carregando = false;
        });
      } else {
        setState(() {
          erro = 'Falha ao carregar dados (${resp.statusCode})';
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = 'Erro: $e';
        carregando = false;
      });
    }
  }

  Future<void> _carregarOrgaos() async {
    try {
      final baseUrl = apiBaseUrl();
      final r = await http.get(Uri.parse('$baseUrl/orgaos'));
      if (r.statusCode == 200) {
        final list = jsonDecode(r.body) as List<dynamic>;
        orgaos = list.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
  }

  Future<void> _salvarPerfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sessão expirada. Faça login novamente.')),
        );
        return;
      }

      final body = {
        'nome': nomeCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'telefone': telefoneCtrl.text.trim().isEmpty ? null : telefoneCtrl.text.trim(),
        'id_orgao_executor': orgaoId,
      };

      final baseUrl = apiBaseUrl();
      final resp = await http.put(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso')),
        );
        // refetch opcional para atualizar orgao_nome
        await _carregarPerfil();
      } else {
        String msg = 'Falha ao salvar (${resp.statusCode})';
        try {
          final err = jsonDecode(resp.body);
          if (err is Map && err['error'] is String) {
            msg = err['error'] as String;
          }
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados da conta')),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: carregando
            ? const Center(child: CircularProgressIndicator())
            : erro != null
                ? Center(child: Text(erro!))
                : ListView(
                    children: [
                      const Text(
                        'Dados da conta',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),

                      // Nome
                      TextField(
                        controller: nomeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // E-mail
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Telefone
                      TextField(
                        controller: telefoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Órgão executor (nome e seletor)
                      DropdownButtonFormField<int>(
                        value: orgaoId,
                        items: orgaos
                            .map((o) => DropdownMenuItem<int>(
                                  value: o['id'] as int,
                                  child: Text(o['nome'] as String),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => orgaoId = v),
                        decoration: const InputDecoration(
                          labelText: 'Órgão executor',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _salvarPerfil,
                          child: const Text('Salvar alterações'),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _linha(String rotulo, String? valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              rotulo,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(valor ?? '—')),
        ],
      ),
    );
  }
}
