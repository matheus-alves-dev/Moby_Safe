import { Router, Request, Response } from 'express';
import multer from 'multer';

import { query } from '../database/db';

const router = Router();
const upload = multer(); // armazena em memória

router.post('/', upload.single('arquivo'), async (
  req: Request & { file?: Express.Multer.File },
  res: Response,
) => {
  try {
    const { titulo, autor_nome, auditor_nome, mapeamento_id } = req.body as { titulo?: string; autor_nome?: string; auditor_nome?: string; mapeamento_id?: number | string };
    const file = req.file;
    if (!file) return res.status(400).json({ error: 'arquivo ausente' });
    const pdf = file.buffer;
    let nomeAutor = autor_nome ?? auditor_nome ?? null;
    let mapeamentoId: number | null = null;
    if (mapeamento_id !== undefined && mapeamento_id !== null) {
      const parsed = Number(mapeamento_id);
      if (Number.isFinite(parsed)) {
        mapeamentoId = parsed;
        const mRows = await query<{ auditor_nome: string }>(
          'SELECT auditor_nome FROM mapeamentos WHERE id = $1 LIMIT 1',
          [mapeamentoId],
        );
        if (mRows.length > 0) {
          nomeAutor = mRows[0].auditor_nome;
        }
      }
    }

    const rows = await query<{ id: number; titulo: string; autor_nome: string | null; criado_em: string }>(
      `INSERT INTO relatorios (titulo, autor_nome, arquivo, mapeamento_id)
       VALUES ($1, $2, $3, $4)
       RETURNING id, titulo, autor_nome, criado_em`,
      [titulo || 'Relatório de Inspeção', nomeAutor, pdf, mapeamentoId]
    );

    return res.status(201).json(rows[0]);
  } catch (e: any) {
    return res.status(500).json({ error: e.message ?? 'erro interno' });
  }
});

router.get('/', async (_req: Request, res: Response) => {
  const rows = await query<{ id: number; titulo: string; autor_nome: string | null; criado_em: string }>(
    `SELECT r.id,
            r.titulo,
            COALESCE(r.autor_nome, m.auditor_nome) AS autor_nome,
            r.criado_em
     FROM relatorios r
     LEFT JOIN mapeamentos m ON m.id = r.mapeamento_id
     ORDER BY r.criado_em DESC`
  );
  return res.json(rows);
});

router.get('/:id/arquivo', async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  const rows = await query<{ arquivo: Buffer }>('SELECT arquivo FROM relatorios WHERE id = $1', [id]);
  if (rows.length === 0) return res.status(404).json({ error: 'não encontrado' });

  res.setHeader('Content-Type', 'application/pdf');
  res.setHeader('Content-Disposition', `attachment; filename=relatorio_${id}.pdf`);
  return res.send(rows[0].arquivo);
});

export default router;