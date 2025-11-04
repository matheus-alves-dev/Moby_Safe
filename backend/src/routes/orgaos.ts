import { Router } from 'express';
import { query } from '../database/db';

const router = Router();

router.get('/', async (_req, res) => {
  try {
    const rows = await query<{ id: number; nome: string }>(
      'SELECT id, nome FROM orgaos_executor ORDER BY nome'
    );
    return res.json(rows);
  } catch (err) {
    console.error('Erro ao listar órgãos:', err);
    return res.status(500).json({ error: 'Erro interno' });
  }
});

export default router;