## Inicialização rápida

Use o arquivo único `Start.sh` depois de clonar o repositório:

```bash
git clone https://github.com/callonlogin-ops/credit-store.git
cd credit-store
chmod +x Start.sh Index.sh
./Start.sh install
nano .env.local
./Start.sh migrate
./Start.sh start
```

Para executar instalação, migração e inicialização:

```bash
./Start.sh all
```

Para abrir o cadastro do Google Play Console:

```bash
./Start.sh play-console
```

Link: https://play.google.com/console/u/0/signup

`Start.sh` delega a execução ao `Index.sh`, instala pacotes do Termux quando detectado e torna os scripts executáveis. Ele não executa `fastboot flash boot`, não instala ISO do Windows e não altera dispositivos Android. Essas operações são independentes e potencialmente destrutivas.
