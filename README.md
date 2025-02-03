# projetoWk
Aplicativo para avaliação de conheciementos

Nete projeto a ideia é a aplicação de SOLID, MVC e Clean Code que significa estruturando o código de forma 
que cada parte tenha uma única responsabilidade, as camadas (Model, View, Controller/Service)       fiquem 
desacopladas e o código seja legível, fácil de testar e de manter. 

1. SOLID
S – Single Responsibility Principle (Princípio da Responsabilidade Única):
    Cada classe ou módulo deve ter apenas uma razão para mudar.
O – Open/Closed Principle (Princípio Aberto/Fechado):
    As classes devem ser abertas para extensão, mas fechadas para modificação.
L – Liskov Substitution Principle (Princípio da Substituição de Liskov):
    Classes derivadas devem poder substituir suas classes base sem alterar o comportamento esperado.
    Exemplo:
I – Interface Segregation Principle (Princípio da Segregação de Interface):
    Prefira interfaces específicas e pequenas em vez de uma única interface grande e abrangente.
D – Dependency Inversion Principle (Princípio da Inversão de Dependência):
    Dependa de abstrações (interfaces), não de implementações concretas.

2. MVC (Model-View-Controller) ou V (View) + M (Model) + S (Service)
Model:
Representa os dados e as regras de negócio (ex.: DTOs como TPedidosDadosGeraisDTO, TPedidosProdutosDTO, e repositórios que acessam o banco de dados).
View:
São os formulários (como uPedidos, FrmConsultaPedidos) que exibem os dados e capturam a entrada do usuário. A view não deve conter lógica de negócio.
Controller/Service:
Gerencia as interações entre a View e o Model (ex.: TPedidoService, TPedidoController). Essa camada coordena a lógica de negócio, invoca métodos  dos 
repositórios e atualiza as views.

3. Clean Code
- Legibilidade e Nomenclatura Consistente:
- Modularização:
- Separação de Preocupações:


