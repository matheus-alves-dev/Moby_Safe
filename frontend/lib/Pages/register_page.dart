import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moby_safe/Pages/login_page.dart';
import 'package:moby_safe/core/api_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController telefoneCtrl = TextEditingController();
  final TextEditingController senhaCtrl = TextEditingController();
  final TextEditingController senha2Ctrl = TextEditingController();

  bool isLoading = false;
  List<Map<String, dynamic>> orgaos = [];
  int? selectedOrgaoId;

  @override
  void initState() {
    super.initState();
    _loadOrgaos();
  }

  Future<void> _loadOrgaos() async {
    try {
      const baseUrl = 'http://localhost:3001'; // Android emulador: http://10.0.2.2:3001
      final uri = Uri.parse('$baseUrl/orgaos');
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is List) {
          setState(() {
            orgaos = data.cast<Map<String, dynamic>>();
          });
        }
      } else {
        _showSnack('Falha ao carregar órgãos (${resp.statusCode})');
      }
    } catch (e) {
      _showSnack('Erro ao carregar órgãos: $e');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _register() async {
    final nome = nomeCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final telefone = telefoneCtrl.text.trim();
    final senha = senhaCtrl.text;
    final senha2 = senha2Ctrl.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || selectedOrgaoId == null) {
      _showSnack('Preencha nome, email, senha e selecione o órgão');
      return;
    }
    if (senha != senha2) {
      _showSnack('As senhas não coincidem');
      return;
    }

    setState(() => isLoading = true);

    try {
      final baseUrl = apiBaseUrl();
      final uri = Uri.parse('$baseUrl/auth/register');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'telefone': telefone.isEmpty ? null : telefone,
          'senha': senha,
          'id_orgao_executor': selectedOrgaoId,
        }),
      );

      if (resp.statusCode == 201) {
        _showSnack('Cadastro realizado com sucesso');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        String msg = 'Falha ao cadastrar';
        try {
          final err = jsonDecode(resp.body);
          if (err is Map && err['error'] is String) {
            msg = err['error'] as String;
          }
        } catch (_) {}
        _showSnack(msg);
      }
    } catch (e) {
      _showSnack('Erro de rede: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MobSafety',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Text(
              'Inspeção de Segurança Viária',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text(
              'Criar conta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: telefoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: selectedOrgaoId,
              items: orgaos
                  .map((o) => DropdownMenuItem<int>(
                        value: o['id'] as int,
                        child: Text(o['nome'] as String),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => selectedOrgaoId = v),
              decoration: const InputDecoration(
                labelText: 'Órgão executor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: senhaCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: senha2Ctrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: isLoading ? null : _register,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Cadastrar'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('Já tenho conta'),
            ),
          ],
        ),
      ),
    );
  }
}