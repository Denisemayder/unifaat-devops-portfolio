# Aula 03 — Terraform + IAM | Denise Macedo (6325028)

## Design da Estrutura IAM

Criei a estrutura IAM da TechNova com separacao de responsabilidades em dois grupos:

- **developers**: acesso somente leitura ao S3 em buckets technova-*, sem poder deletar nada
- **platform-eng**: acesso mais amplo a EC2 e S3, limitado a recursos com tag Project=TechNova

Os usuarios foram distribuidos conforme suas funcoes:
- **juliana-dev** e **lucas-intern**: grupo developers (leitura)
- **rafael-platform**: ambos os grupos (dev + platform)

## Principio do Menor Privilegio

Cada usuario recebe apenas o minimo necessario para seu trabalho.

Exemplo 1: A policy s3-read permite apenas GetObject e ListBucket em buckets
technova-* — Juliana pode ler arquivos mas nao pode criar, modificar ou deletar nada.

Exemplo 2: A policy deny-destructive aplica Deny explicito para Delete*, Terminate*
e iam:Delete* — mesmo que alguem ganhe outra policy com Allow, o Deny sempre prevalece.

Se usasse AmazonS3FullAccess em vez da custom policy, qualquer dev poderia
apagar buckets inteiros acidentalmente ou acessar dados de outros projetos.

## Diagrama de Permissoes

```
juliana-dev  ─┐
lucas-intern ─┤─► developers ─► s3-read (GetObject, ListBucket em technova-*)
rafael       ─┘               ─► deny-destructive (Deny Delete*, Terminate*, iam:Delete*)

rafael ──────────► platform-eng ─► ec2-s3-full (EC2 Describe/Start/Stop + S3 completo)
                                   (com Condition: tag Project=TechNova)

EC2 ─► ec2-role ─► ec2-profile ─► S3 technova-app-data-* (GetObject, PutObject)
(documentado em roles.tf — iam:CreateRole bloqueado no AWS Academy)
```

## Comandos Utilizados

```bash
terraform init
terraform validate
terraform plan
terraform plan 2>&1 | tee terraform-plan-output.txt
terraform apply
terraform destroy
```

## Limitacao do AWS Academy

O ambiente AWS Academy Learner Lab bloqueia iam:CreateGroup, iam:CreateUser,
iam:CreateRole e iam:TagPolicy por restricao da role voclabs.
As 3 custom policies foram criadas com sucesso. A role e os grupos/usuarios
estao documentados no codigo como comentarios para demonstrar o design completo.

## Reflexao

Criar IAM pelo console AWS e rapido para um recurso, mas nao escala.
Com Terraform, toda a estrutura esta versionada no Git — qualquer alteracao
fica registrada com quem fez, quando e por que. Para uma equipe isso e essencial:
auditoria, rollback e revisao de codigo em qualquer mudanca de permissao.
Alem disso, o codigo pode ser aplicado em multiplos ambientes (dev, staging, prod)
com apenas uma mudanca de variavel.
