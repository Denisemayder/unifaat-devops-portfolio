# Aula 05 — RDS e Remote State | Denise Macedo (6325028)

## Infraestrutura Criada

- VPC com CIDR 10.0.0.0/16
- 1 subnet publica (EC2) em us-east-1a
- 2 subnets privadas (RDS) em us-east-1a e us-east-1b
- Internet Gateway + Route Table publica
- Security Group EC2: porta 22 e 3000 abertas
- Security Group RDS: porta 5432 apenas do SG do EC2
- RDS PostgreSQL 15 (db.t3.micro) nas subnets privadas
- EC2 Amazon Linux 2023 na subnet publica
- DynamoDB para lock do state (S3 bloqueado pelo AWS Academy)

## Evidencia da Conexao EC2 para RDS

```
psql -h technova-db-6325028.cyxchmww8xse.us-east-1.rds.amazonaws.com
     -U technovaadmin -d technova -c "SELECT version();"

PostgreSQL 15.17 on x86_64-pc-linux-gnu, compiled by gcc 12.4.0, 64-bit
```

## Evidencia de Dados Persistentes

```
CREATE TABLE orders (id SERIAL PRIMARY KEY, produto VARCHAR(100), quantidade INT);
INSERT INTO orders VALUES ('Produto A', 10), ('Produto B', 25);
SELECT * FROM orders;

 id |  produto  | quantidade
----+-----------+------------
  1 | Produto A |         10
  2 | Produto B |         25
```

## Remote State

Configurado com backend S3 + DynamoDB lock.
O AWS Academy bloqueia s3:GetBucketObjectLockConfiguration via SCP da organizacao.
O backend esta documentado no providers.tf. O DynamoDB de lock foi criado com sucesso.

## Reflexao

O Remote State resolve um problema critico em times: sem ele, o tfstate fica
na maquina de cada pessoa e dois devs rodando terraform apply ao mesmo tempo
podem corromper a infraestrutura. Com S3 + DynamoDB, o state fica centralizado
e travado enquanto alguem esta aplicando mudancas.
