import { Router } from 'express';
import { query } from '../database/db';

type Mapeamento = {
  id: number;
  data_inspecao: string | null;
  auditor_nome: string;
  nome_via: string;
  extensao_trecho: string | null;
  created_at: string;
  updated_at: string;
};

const router = Router();

router.get('/', async (_req, res) => {
  try {
    const rows = await query<Mapeamento>(
      'SELECT id, data_inspecao, auditor_nome, nome_via, extensao_trecho, created_at, updated_at FROM mapeamentos ORDER BY id DESC'
    );
    return res.json(rows);
  } catch (err) {
    return res.status(500).json({ error: 'Erro interno' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isFinite(id)) {
      return res.status(400).json({ error: 'ID inválido' });
    }
    const rows = await query<Mapeamento>(
      'SELECT id, data_inspecao, auditor_nome, nome_via, extensao_trecho, created_at, updated_at FROM mapeamentos WHERE id = $1',
      [id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Registro não encontrado' });
    }
    return res.json(rows[0]);
  } catch (err) {
    return res.status(500).json({ error: 'Erro interno' });
  }
});

router.post('/', async (req, res) => {
  try {
    const { data_inspecao, auditor_nome, nome_via, extensao_trecho } = req.body as {
      data_inspecao?: string | null;
      auditor_nome?: string;
      nome_via?: string;
      extensao_trecho?: string | null;
    };

    if (!auditor_nome || !nome_via) {
      return res.status(400).json({ error: 'Campos obrigatórios: auditor_nome, nome_via' });
    }

    const inserted = await query<{ id: number }>(
      'INSERT INTO mapeamentos (data_inspecao, auditor_nome, nome_via, extensao_trecho) VALUES ($1, $2, $3, $4) RETURNING id',
      [data_inspecao ?? null, auditor_nome, nome_via, extensao_trecho ?? null]
    );
    return res.status(201).json({ id: inserted[0].id });
  } catch (err) {
    return res.status(500).json({ error: 'Erro interno' });
  }
});

router.put('/:id', async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isFinite(id)) {
      return res.status(400).json({ error: 'ID inválido' });
    }
    const { data_inspecao, auditor_nome, nome_via, extensao_trecho } = req.body as {
      data_inspecao?: string | null;
      auditor_nome?: string;
      nome_via?: string;
      extensao_trecho?: string | null;
    };

    const sets: string[] = [];
    const params: any[] = [];
    let idx = 1;

    if (data_inspecao !== undefined) {
      sets.push(`data_inspecao = $${idx++}`);
      params.push(data_inspecao);
    }
    if (auditor_nome !== undefined) {
      sets.push(`auditor_nome = $${idx++}`);
      params.push(auditor_nome);
    }
    if (nome_via !== undefined) {
      sets.push(`nome_via = $${idx++}`);
      params.push(nome_via);
    }
    if (extensao_trecho !== undefined) {
      sets.push(`extensao_trecho = $${idx++}`);
      params.push(extensao_trecho);
    }

    if (sets.length === 0) {
      return res.status(400).json({ error: 'Nenhum campo para atualizar' });
    }

    params.push(id);
    const sql = `UPDATE mapeamentos SET ${sets.join(', ')} WHERE id = $${idx} RETURNING id`;
    const updated = await query<{ id: number }>(sql, params);
    if (updated.length === 0) {
      return res.status(404).json({ error: 'Registro não encontrado' });
    }
    return res.json({ id: updated[0].id });
  } catch (err) {
    return res.status(500).json({ error: 'Erro interno' });
  }
});

export default router;
