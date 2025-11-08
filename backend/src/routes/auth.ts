import { Router, Request, Response } from 'express';
import { query } from '../database/db';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

type Usuario = {
  id: number;
  email: string;
  senha: string; // armazenada como hash bcrypt
  // adicione outros campos se precisar: nome, role, etc.
};

const router = Router();

router.post('/login', async (req: Request, res: Response) => {
  try {
    const { email, senha } = req.body as { email?: string; senha?: string };

    if (!email || !senha) {
      return res.status(400).json({ error: 'Informe email e senha' });
    }

    const rows = await query<Usuario>(
      'SELECT id, email, senha FROM usuarios WHERE email = $1 LIMIT 1',
      [email]
    );

    if (rows.length === 0) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const usuario = rows[0];

    const ok = await bcrypt.compare(senha, usuario.senha);
    if (!ok) {
      // Se sua senha estiver em texto puro (não recomendado), você poderia
      // permitir a comparação direta. Para segurança, mantenha bcrypt e migre
      // os registros para hash.
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    const secret = process.env.JWT_SECRET;
    if (!secret) {
      return res.status(500).json({ error: 'JWT_SECRET ausente na configuração' });
    }

    const token = jwt.sign(
      { sub: usuario.id, email: usuario.email },
      secret,
      { expiresIn: '12h' }
    );

    return res.json({
      token,
      user: { id: usuario.id, email: usuario.email },
    });
  } catch (err) {
    console.error('Erro no login:', err);
    return res.status(500).json({ error: 'Erro interno' });
  }
});

router.post('/register', async (req: Request, res: Response) => {
  try {
    const { nome, email, telefone, senha, orgaoId, id_orgao_executor } = req.body as {
      nome?: string;
      email?: string;
      telefone?: string;
      senha?: string;
      orgaoId?: number;
      id_orgao_executor?: number;
    };

    const orgaoExecutorId = orgaoId ?? id_orgao_executor;

    if (!nome || !email || !senha || !orgaoExecutorId) {
      return res.status(400).json({ error: 'Campos obrigatórios: nome, email, senha, orgaoId/id_orgao_executor' });
    }

    const existing = await query('SELECT 1 FROM usuarios WHERE email = $1 LIMIT 1', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ error: 'E-mail já cadastrado' });
    }

    const orgao = await query('SELECT id FROM orgaos_executor WHERE id = $1', [orgaoExecutorId]);
    if (orgao.length === 0) {
      return res.status(400).json({ error: 'Órgão executor inválido' });
    }

    const hash = await bcrypt.hash(senha, 10);
    const inserted = await query<{ id: number }>(
      'INSERT INTO usuarios (nome, email, telefone, senha, id_orgao_executor) VALUES ($1, $2, $3, $4, $5) RETURNING id',
      [nome, email, telefone ?? null, hash, orgaoExecutorId]
    );

    return res.status(201).json({ id: inserted[0].id });
  } catch (err) {
    console.error('Erro no cadastro:', err);
    return res.status(500).json({ error: 'Erro interno' });
  }
});

// Retorna dados do usuário autenticado
router.get('/me', async (req: Request, res: Response) => {
  try {
    const auth = req.headers.authorization;
    if (!auth || !auth.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Token ausente' });
    }
    const token = auth.substring('Bearer '.length);
    const secret = process.env.JWT_SECRET;
    if (!secret) {
      return res.status(500).json({ error: 'JWT_SECRET ausente na configuração' });
    }

    let decoded: any;
    try {
      decoded = jwt.verify(token, secret) as jwt.JwtPayload;
    } catch {
      return res.status(401).json({ error: 'Token inválido' });
    }

    const userId = Number(decoded.sub);
    const rows = await query<{
      id: number;
      nome: string;
      email: string;
      telefone: string | null;
      id_orgao_executor: number;
      orgao_executor_nome: string | null;
    }>(
      `SELECT u.id, u.nome, u.email, u.telefone, u.id_orgao_executor,
              o.nome AS orgao_executor_nome
       FROM usuarios u
       LEFT JOIN orgaos_executor o ON o.id = u.id_orgao_executor
       WHERE u.id = $1`,
      [userId]
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Usuário não encontrado' });
    }
    return res.json(rows[0]);
  } catch (err) {
    console.error('Erro ao obter perfil:', err);
    return res.status(500).json({ error: 'Erro interno' });
  }
});
export default router;

// Atualiza dados do usuário autenticado
router.put('/me', async (req: Request, res: Response) => {
  try {
    const auth = req.headers.authorization;
    if (!auth || !auth.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Token ausente' });
    }
    const token = auth.substring('Bearer '.length);
    const secret = process.env.JWT_SECRET;
    if (!secret) {
      return res.status(500).json({ error: 'JWT_SECRET ausente na configuração' });
    }

    let decoded: any;
    try {
      decoded = jwt.verify(token, secret) as jwt.JwtPayload;
    } catch {
      return res.status(401).json({ error: 'Token inválido' });
    }

    const userId = Number(decoded.sub);
    const { nome, email, telefone, id_orgao_executor } = req.body as {
      nome?: string;
      email?: string;
      telefone?: string | null;
      id_orgao_executor?: number;
    };

    const sets: string[] = [];
    const params: any[] = [];
    let idx = 1;

    if (nome !== undefined) {
      sets.push(`nome = $${idx++}`);
      params.push(nome);
    }
    if (email !== undefined) {
      // valida e-mail duplicado
      const exists = await query('SELECT 1 FROM usuarios WHERE email = $1 AND id <> $2 LIMIT 1', [email, userId]);
      if (exists.length > 0) {
        return res.status(409).json({ error: 'E-mail já está em uso' });
      }
      sets.push(`email = $${idx++}`);
      params.push(email);
    }
    if (telefone !== undefined) {
      sets.push(`telefone = $${idx++}`);
      params.push(telefone);
    }
    if (id_orgao_executor !== undefined) {
      const orgao = await query('SELECT 1 FROM orgaos_executor WHERE id = $1', [id_orgao_executor]);
      if (orgao.length === 0) {
        return res.status(400).json({ error: 'Órgão executor inválido' });
      }
      sets.push(`id_orgao_executor = $${idx++}`);
      params.push(id_orgao_executor);
    }

    if (sets.length === 0) {
      return res.status(400).json({ error: 'Nenhum campo para atualizar' });
    }

    params.push(userId);
    const sql = `UPDATE usuarios SET ${sets.join(', ')} WHERE id = $${idx} RETURNING id`;
    const updated = await query<{ id: number }>(sql, params);
    return res.json({ id: updated[0].id });
  } catch (err) {
    console.error('Erro ao atualizar perfil:', err);
    return res.status(500).json({ error: 'Erro interno' });
  }
});