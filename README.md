# MaisEvento API

MaisEvento é uma API RESTful para gerenciamento de eventos e autenticação de usuários, construída com Dart e seguindo os princípios de Clean Architecture.

## Arquitetura

O projeto segue a Clean Architecture, dividida em camadas:

1. **Domain**: Contém as entidades de negócio, casos de uso e interfaces de repositórios.
2. **Data**: Implementa os repositórios e fontes de dados.
3. **Presentation**: Contém os controladores que lidam com as requisições HTTP.
4. **Infrastructure**: Serviços de infraestrutura como banco de dados e JWT.

## Principais Componentes

- **Entities**: `User`, `Event`
- **Use Cases**: `CreateUserUseCase`, `LoginUseCase`, `CreateEventUseCase`, `GetAllEventsUseCase`
- **Repositories**: `UserRepository`, `EventRepository`
- **Data Sources**: `UserDataSource`, `EventDataSource`
- **Controllers**: `UserController`, `EventController`
- **Services**: `DatabaseService`, `JwtService`

## Endpoints da API

### Gerenciamento de Usuários

#### Registrar um novo usuário
- **POST** `/register`
- Corpo: `{ "name": "Nome do Usuário", "email": "usuario@exemplo.com", "password": "senha123" }`

#### Login do Usuário
- **POST** `/login`
- Corpo: `{ "email": "usuario@exemplo.com", "password": "senha123" }`

### Gerenciamento de Eventos

#### Criar um novo evento
- **POST** `/events`
- Autenticação: Bearer Token
- Corpo:
  ```json
  {
    "title": "Nome do Evento",
    "description": "Descrição do Evento",
    "date": "2023-06-15T14:30:00.000Z",
    "location": "Local do Evento",
    "activities": ["Atividade 1", "Atividade 2"],
    "capacity": 100
  }
  ```

#### Obter todos os eventos
- **GET** `/events`
- Autenticação: Bearer Token

## Configuração e Execução

1. Certifique-se de ter o SDK do Dart instalado.
2. Clone o repositório.
3. Execute `dart pub get` para instalar as dependências.
4. Crie um arquivo `.env` na raiz do projeto com a seguinte variável:
   ```
   MONGODB_CONNECTION_STRING=sua_string_de_conexao_mongodb
   ```
5. Execute o servidor: `dart run bin/server.dart`

O servidor iniciará em `localhost:8080`.

## Dependências Principais

- shelf: Para criação do servidor HTTP
- mongo_dart: Para conexão com MongoDB
- get_it: Para injeção de dependências
- jaguar_jwt: Para geração e validação de JWT
- dotenv: Para carregamento de variáveis de ambiente

## Testes

Os testes unitários e de integração podem ser executados com o comando:
