# Execução com um único arquivo

Depois de clonar o projeto:

```bash
git clone https://github.com/callonlogin-ops/credit-store.git
cd credit-store
chmod +x Index.sh
./Index.sh install
```

O `Index.sh` instala/sincroniza dependências, cria `.env.local` sem sobrescrever configurações existentes, gera o cliente Prisma e prepara o projeto.

Edite as variáveis:

```bash
nano .env.local
```

Para sincronizar o banco e iniciar tudo:

```bash
./Index.sh migrate
./Index.sh start
```

Ou faça tudo em sequência — incluindo a migração — com:

```bash
./Index.sh all
```

Para abrir o editor automaticamente durante a instalação:

```bash
EDIT_ENV=1 ./Index.sh install
```

Para criar somente o build de produção:

```bash
./Index.sh build
```

O script não cria nem expõe credenciais de S3/R2, PostgreSQL, Play Console, Apple ou Amazon. Configure esses valores em `.env.local` e use secrets no CI/CD.
