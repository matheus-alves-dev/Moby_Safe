// lib/services/rascunho_service.dart
class RascunhoService {
  RascunhoService._();
  static final RascunhoService instance = RascunhoService._();

  // Armazena coletas em memória (simula um banco local)
  final List<Map<String, dynamic>> _coletas = <Map<String, dynamic>>[];

  /// Getter público (somente leitura)
  List<Map<String, dynamic>> get coletas => List.unmodifiable(_coletas);

  /// Adiciona uma nova coleta ou atualiza se o id já existir
  void adicionarColeta(Map<String, dynamic> coleta) {
    final String id = (coleta['id'] ?? '').toString();
    if (id.isEmpty) return;

    // Remove duplicadas com o mesmo ID antes de adicionar
    _coletas.removeWhere((c) => (c['id'] ?? '').toString() == id);

    _coletas.add({
      'id': id,
      'observacao': coleta['observacao'] ?? '',
      'latitude': coleta['latitude'],
      'longitude': coleta['longitude'],
      'fotos': List<String>.from(
        (coleta['fotos'] as List?)?.map((e) => e.toString()) ?? const [],
      ),
      'criadoEm': coleta['criadoEm'] ?? DateTime.now().toIso8601String(),
    });
  }

  /// Retorna uma coleta pelo ID (ou null se não encontrada)
  Map<String, dynamic>? findById(String id) {
    for (final c in _coletas) {
      if ((c['id'] ?? '').toString() == id) return c;
    }
    return null;
  }

  /// Remove uma coleta específica pelo ID
  void removerColeta(String id) {
    _coletas.removeWhere((c) => (c['id'] ?? '').toString() == id);
  }

  /// Limpa todas as coletas (simula envio)
  void limparColetas() {
    _coletas.clear();
  }
}
