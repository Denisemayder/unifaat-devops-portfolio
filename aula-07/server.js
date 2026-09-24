const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Dados em memória
let salas = [];
let reservas = [];
let proximoIdSala = 1;
let proximoIdReserva = 1;

// POST /salas — cadastrar sala
app.post('/salas', (req, res) => {
  const { nome, capacidade } = req.body;
  if (!nome) {
    return res.status(400).json({ erro: 'Nome da sala é obrigatório' });
  }
  const sala = { id: proximoIdSala++, nome, capacidade: capacidade || 0 };
  salas.push(sala);
  res.status(201).json(sala);
});

// GET /salas — listar salas
app.get('/salas', (req, res) => {
  res.json(salas);
});

// POST /reservas — criar reserva com validação de conflito
app.post('/reservas', (req, res) => {
  const { salaId, funcionario, horario } = req.body;

  if (!salaId || !funcionario || !horario) {
    return res.status(400).json({ erro: 'salaId, funcionario e horario são obrigatórios' });
  }

  const sala = salas.find(s => s.id === salaId);
  if (!sala) {
    return res.status(404).json({ erro: 'Sala não encontrada' });
  }

  // Verificar conflito de horário
  const conflito = reservas.find(r => r.salaId === salaId && r.horario === horario);
  if (conflito) {
    return res.status(409).json({
      erro: `Sala "${sala.nome}" já está reservada no horário ${horario}`
    });
  }

  const reserva = { id: proximoIdReserva++, salaId, nomeSala: sala.nome, funcionario, horario };
  reservas.push(reserva);
  res.status(201).json(reserva);
});

// DELETE /reservas/:id — cancelar reserva
app.delete('/reservas/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = reservas.findIndex(r => r.id === id);
  if (index === -1) {
    return res.status(404).json({ erro: 'Reserva não encontrada' });
  }
  reservas.splice(index, 1);
  res.json({ mensagem: `Reserva ${id} cancelada com sucesso` });
});

// GET /reservas?funcionario=NOME — listar reservas de um funcionário
app.get('/reservas', (req, res) => {
  const { funcionario } = req.query;
  if (funcionario) {
    const resultado = reservas.filter(r =>
      r.funcionario.toLowerCase() === funcionario.toLowerCase()
    );
    return res.json(resultado);
  }
  res.json(reservas);
});

app.listen(PORT, () => {
  console.log(`TechNova Reserva de Salas rodando na porta ${PORT}`);
});
