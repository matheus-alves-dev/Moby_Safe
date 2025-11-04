import express from 'express';
import cors from 'cors';
import authRouter from './routes/auth';
import orgaosRouter from './routes/orgaos';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/auth', authRouter);
app.use('/orgaos', orgaosRouter);

export default app;