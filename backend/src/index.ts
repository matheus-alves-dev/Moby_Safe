console.log('Backend iniciado em TypeScript');
import dotenv from 'dotenv';
import app from './app';

dotenv.config();

const PORT = process.env.PORT ? Number(process.env.PORT) : 3001;
app.listen(PORT, () => {
  console.log(`API ouvindo em http://localhost:${PORT}`);
});