import express from 'express';
import cors from 'cors';
import authRouter from './routes/auth';
import orgaosRouter from './routes/orgaos';
import mapeamentosRouter from './routes/mapeamentos';
import relatoriosRouter from './routes/relatorios';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/auth', authRouter);
app.use('/orgaos', orgaosRouter);
app.use('/mapeamentos', mapeamentosRouter);
app.use('/relatorios', relatoriosRouter);

export default app;
