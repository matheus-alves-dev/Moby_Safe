import express from 'express';
import cors from 'cors';
import authRouter from './routes/auth';
import orgaosRouter from './routes/orgaos';
import mapeamentosRouter from './routes/mapeamentos';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/auth', authRouter);
app.use('/orgaos', orgaosRouter);
app.use('/mapeamentos', mapeamentosRouter);

export default app;
