const request = require('supertest');
const app = require('../server');

describe('TechNova API - Aula 08', () => {
  test('POST /salas - deve cadastrar uma sala', async () => {
    const response = await request(app)
      .post('/salas')
      .send({ nome: 'Sala DevOps', capacidade: 10 });

    expect(response.status).toBe(201);
    expect(response.body.nome).toBe('Sala DevOps');
  });

  test('POST /salas - deve rejeitar sala sem nome', async () => {
    const response = await request(app)
      .post('/salas')
      .send({ capacidade: 5 });

    expect(response.status).toBe(400);
  });

  test('GET /salas - deve listar salas', async () => {
    const response = await request(app).get('/salas');

    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });

  test('POST /reservas - deve rejeitar dados incompletos', async () => {
    const response = await request(app)
      .post('/reservas')
      .send({ funcionario: 'Denise' });

    expect(response.status).toBe(400);
  });
});
