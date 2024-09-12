# API MaisEvento

MaisEvento é uma API RESTful para gerenciamento de eventos e autenticação de usuários. Ela fornece endpoints para registro de usuários, login, criação e recuperação de eventos.

## Propósito

O objetivo deste projeto é fornecer um serviço de backend para aplicações de gerenciamento de eventos. Ele permite que os usuários criem contas, se autentiquem e gerenciem eventos. Esta API pode ser usada como base para construir sistemas de planejamento e gerenciamento de eventos, plataformas de encontros sociais ou qualquer aplicação que necessite de recursos de organização de eventos.

## Endpoints da API

### Gerenciamento de Usuários

#### Registrar um novo usuário
- **POST** `/register`
- Corpo: `{ "name": "Nome do Usuário", "email": "usuario@exemplo.com", "password": "senha123" }`
- Resposta: Mensagem de sucesso ou detalhes do erro

#### Login do Usuário
- **POST** `/login`
- Corpo: `{ "email": "usuario@exemplo.com", "password": "senha123" }`
- Resposta: Token de acesso e token de atualização, ou detalhes do erro

#### Atualizar Token
- **POST** `/refresh`
- Corpo: `{ "refreshToken": "seu_token_de_atualizacao_aqui" }`
- Resposta: Novo token de acesso e token de atualização, ou detalhes do erro

### Gerenciamento de Eventos

#### Criar um novo evento
- **POST** `/event`
- Cabeçalhos: `Authorization: Bearer seu_token_de_acesso_aqui`
- Corpo: 
  ```json
  {
    "name": "Nome do Evento",
    "description": "Descrição do Evento",
    "date": "2023-06-15T14:30:00.000Z",
    "location": "Local do Evento",
    "capacity": 100,
    "activities": ["Atividade 1", "Atividade 2"]
  }
  ```
- Resposta: Mensagem de sucesso ou detalhes do erro

#### Obter todos os eventos
- **GET** `/event`
- Resposta: Lista de todos os eventos ou detalhes do erro

## Autenticação

A API usa JWT (JSON Web Tokens) para autenticação. Após o login bem-sucedido, o cliente recebe um token de acesso e um token de atualização. O token de acesso deve ser incluído no cabeçalho `Authorization` para rotas protegidas (por exemplo, criação de evento).

## Armazenamento de Dados

A API usa MongoDB para armazenamento de dados. Certifique-se de configurar sua string de conexão MongoDB na classe `DatabaseService`.

## Executando o Projeto

1. Certifique-se de ter o SDK do Dart instalado.
2. Clone o repositório.
3. Execute `dart pub get` para instalar as dependências.
4. Configure sua string de conexão MongoDB em `lib/services/database_service.dart`.
5. Execute o servidor usando `dart run bin/maisevento.dart`.

O servidor começará a funcionar em `localhost:8080`.

## Melhorias Futuras

- Implementar endpoints de atualização e exclusão de eventos.
- Adicionar funções e permissões de usuário.
- Implementar paginação para listagem de eventos.
- Adicionar validação de entrada e tratamento de erros mais abrangentes.
- Implementar limitação de taxa para prevenir abusos.

## Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para enviar um Pull Request.

## Licença

Este projeto é de código aberto e está disponível sob a [Licença MIT](LICENSE).
