# Projeto E-commerce — Modelagem de Banco de Dados
# Projeto de Banco de Dados E-commerce

## 1. Sobre o projeto

Este projeto foi desenvolvido como parte de um desafio de modelagem de banco de dados SQL da Digital Innovation One (DIO).

O objetivo é representar a estrutura de um sistema de comércio eletrónico (e-commerce), contemplando clientes, produtos, fornecedores, vendedores terceiros, pedidos, pagamentos, entregas e controlo de estoque.

O projeto inclui a criação do esquema relacional, definição de chaves primárias e estrangeiras, aplicação de restrições de integridade, inserção de dados para testes e elaboração de consultas SQL para responder a questões de negócio.

## 2. Tecnologias utilizadas

- MySQL
- MySQL Workbench
- SQL
- Git e GitHub

## 3. Modelo lógico da base de dados

A base de dados chama-se `ecommerce_db` e contém 14 tabelas:

| Tabela | Finalidade |
|---|---|
| `cliente` | Regista os clientes e o respetivo tipo: pessoa física (PF) ou pessoa jurídica (PJ). |
| `cliente_pf` | Armazena os dados específicos dos clientes pessoa física. |
| `cliente_pj` | Armazena os dados específicos dos clientes pessoa jurídica. |
| `produto` | Regista os produtos comercializados. |
| `fornecedor` | Armazena os fornecedores. |
| `estoque` | Regista os locais de armazenamento. |
| `terceiro_vendedor` | Armazena os vendedores terceiros do marketplace. |
| `pedido` | Regista os pedidos dos clientes, o estado e o valor do frete. |
| `item_pedido` | Relaciona os produtos com os pedidos, incluindo quantidade e preço unitário. |
| `pagamento` | Regista os pagamentos associados aos pedidos. |
| `entrega` | Armazena o estado da entrega, o código de rastreio e as datas relevantes. |
| `produtos_por_vendedor` | Relaciona produtos com vendedores terceiros e regista as quantidades. |
| `produto_has_fornecedor` | Relaciona produtos com fornecedores. |
| `produto_has_estoque` | Relaciona produtos com locais de estoque e respetivas quantidades. |

## 4. Relacionamentos principais

- **Cliente — Pedido:** um cliente pode realizar vários pedidos.
- **Pedido — Item do pedido:** um pedido pode conter vários itens.
- **Produto — Item do pedido:** um produto pode aparecer em diferentes pedidos.
- **Pedido — Pagamento:** um pedido pode ter vários registos de pagamento, permitindo representar diferentes formas de pagamento.
- **Pedido — Entrega:** cada pedido pode ter, no máximo, um registo de entrega, através da restrição de unicidade em `idPedido`.
- **Produto — Fornecedor:** relacionamento muitos-para-muitos implementado através de `produto_has_fornecedor`.
- **Produto — Estoque:** relacionamento muitos-para-muitos implementado através de `produto_has_estoque`.
- **Produto — Vendedor terceiro:** relacionamento muitos-para-muitos implementado através de `produtos_por_vendedor`.
- **Cliente — Pessoa física/Pessoa jurídica:** os dados específicos são separados nas tabelas `cliente_pf` e `cliente_pj`.

## 5. Regras de negócio

1. Um cliente é identificado como pessoa física (PF) ou pessoa jurídica (PJ).
2. Os dados específicos de PF e PJ são armazenados em tabelas distintas.
3. Um pedido pertence a um cliente.
4. Um pedido pode conter vários produtos.
5. Um pedido pode ter vários registos de pagamento.
6. A entrega possui um estado e pode ter um código de rastreio.
7. A quantidade de produtos por vendedor terceiro pode ser zero.
8. As chaves estrangeiras asseguram a integridade referencial entre as tabelas relacionadas.

**Nota:** a exclusividade entre PF e PJ é uma regra de negócio pretendida. A estrutura atual das chaves primárias e estrangeiras, isoladamente, não impede todos os cenários de um mesmo cliente aparecer nas duas tabelas de especialização. Esta regra deverá ser reforçada com mecanismos adicionais, se for exigida a sua aplicação diretamente na base de dados.

## 6. Consultas SQL e questões de negócio

O projeto utiliza consultas SQL para responder a questões como:

- Quantos pedidos cada cliente realizou?
- Qual é o valor total dos pedidos de cada cliente, incluindo o frete?
- Quais são os produtos vendidos e as respetivas quantidades?
- Qual é o valor total dos pedidos por estado?
- Quais são as formas de pagamento utilizadas?
- Quais são os produtos, fornecedores e locais de estoque relacionados?
- Existe algum vendedor terceiro com a mesma razão social de um fornecedor?
- Existem pedidos sem itens ou registos relacionados em falta?
- Qual é o preço médio, mínimo e máximo dos produtos?

As consultas utilizam recursos como `SELECT`, `WHERE`, expressões calculadas, `ORDER BY`, `GROUP BY`, `HAVING` e `JOIN`.

## 7. Dados de teste

Foram inseridos dados de teste para demonstrar os relacionamentos e permitir a execução das consultas de análise.

Os dados abrangem clientes PF e PJ, produtos, fornecedores, vendedores terceiros, pedidos, itens, pagamentos, entregas e estoque.

## 8. Como executar

1. Instalar o MySQL Server e o MySQL Workbench.
2. Abrir o ficheiro SQL do projeto no MySQL Workbench.
3. Executar o script por etapas, respeitando a ordem de criação das tabelas e inserção dos dados.
4. Executar as consultas analíticas no final do script.

## 9. Objetivo de aprendizagem

Este projeto consolida conhecimentos de modelagem relacional, normalização, chaves primárias e estrangeiras, restrições de integridade, relacionamentos muitos-para-muitos, manipulação de dados e consultas SQL para análise de negócio.