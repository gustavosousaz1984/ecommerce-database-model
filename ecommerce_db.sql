-- criação do banco de dados para o cenario de E-commerce

CREATE DATABASE IF NOT EXISTS ecommerce_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ecommerce_db;

-- =========================================
-- TABELA CLIENTE
-- =========================================

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    tipoCliente ENUM('PF', 'PJ') NOT NULL,
    dataCadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;


-- =========================================
-- TABELA CLIENTE_PF
-- =========================================

CREATE TABLE Cliente_PF (
    idCliente INT PRIMARY KEY,
    Pnome VARCHAR(25) NOT NULL,
    Mnome varchar(3),
    Unome Varchar(25),
    CPF CHAR(11) NOT NULL, 
    endereco varchar(30),
    constraint UNIQUE_CPF_CLIENTE unique(CPF),

    CONSTRAINT fk_cliente_pf
        FOREIGN KEY (idCliente)
        REFERENCES Cliente(idCliente)
        ON DELETE CASCADE
) ENGINE = InnoDB;


-- =========================================
-- TABELA CLIENTE_PJ
-- =========================================

CREATE TABLE Cliente_PJ (
    idCliente INT PRIMARY KEY,
    razaoSocial VARCHAR(150) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE,

    CONSTRAINT fk_cliente_pj
        FOREIGN KEY (idCliente)
        REFERENCES Cliente(idCliente)
        ON DELETE CASCADE
) ENGINE = InnoDB;


-- =========================================
-- TABELA PRODUTO
-- =========================================

CREATE TABLE Produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    categoria enum('Eletronico','Vestimenta','Brinquedos','Alimentos'),
    descricao TEXT,
    valor DECIMAL(10,2) NOT NULL,
    
    CONSTRAINT chk_produto_valor
        CHECK (valor >= 0)
) ENGINE = InnoDB;


-- =========================================
-- TABELA FORNECEDOR
-- =========================================

CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razaoSocial VARCHAR(150) NOT NULL,
    CNPJ CHAR(14) NOT NULL UNIQUE
) ENGINE = InnoDB;


-- =========================================
--  TABELA ESTOQUE
-- =========================================

CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    localEstoque VARCHAR(100) NOT NULL
) ENGINE = InnoDB;

-- =========================================
-- TABELA TERCEIRO VENDEDOR
-- =========================================

CREATE TABLE Terceiro_Vendedor (
    idTerceiroVendedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(45) NOT NULL,
    Local VARCHAR(45),
    NomeFantasia VARCHAR(45),
    Endereco VARCHAR(45)
) ENGINE = InnoDB;


USE ecommerce_db;

SHOW TABLES;

DESCRIBE Cliente;
DESCRIBE Cliente_PF;
DESCRIBE Cliente_PJ;
DESCRIBE Produto;
DESCRIBE Fornecedor;
DESCRIBE Estoque;
DESCRIBE Terceiro_Vendedor;

SHOW TABLES;


SHOW CREATE TABLE cliente_pj;

USE ecommerce_db;

CREATE TABLE IF NOT EXISTS pedido (
    idPedido INT NOT NULL AUTO_INCREMENT,
    idCliente INT NOT NULL,
    statusPedido ENUM(
        'Em processamento',
        'Em transporte',
        'Entregue',
        'Cancelado'
    ) NOT NULL DEFAULT 'Em processamento',
    descricao VARCHAR(255),
    frete DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (idPedido),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (idCliente)
        REFERENCES cliente (idCliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

USE ecommerce_db;

CREATE TABLE IF NOT EXISTS pagamento (
    idPagamento INT NOT NULL AUTO_INCREMENT,
    idPedido INT NOT NULL,
    formaPagamento ENUM('Cartao de credito', 'Cartao de debito', 'Pix', 'Transferencia bancaria', 'Dinheiro', 'MB Way', 'Multibanco') NOT NULL,
    valor DECIMAL(10 , 2 ) NOT NULL,
    dataPagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idPagamento),
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (idPedido)
        REFERENCES pedido (idPedido)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_pagamento_valor CHECK (valor > 0)
)  ENGINE=INNODB;

show tables;

USE ecommerce_db;

CREATE TABLE IF NOT EXISTS entrega (
    idEntrega INT NOT NULL AUTO_INCREMENT,
    idPedido INT NOT NULL,
    statusEntrega VARCHAR(30) NOT NULL DEFAULT 'Em preparação',
    codigoRastreio VARCHAR(45),
    dataEnvio DATETIME,
    dataEntrega DATETIME,
    PRIMARY KEY (idEntrega),
    UNIQUE KEY uq_entrega_pedido (idPedido),
    UNIQUE KEY uq_entrega_rastreio (codigoRastreio),
    CONSTRAINT fk_entrega_pedido
        FOREIGN KEY (idPedido)
        REFERENCES pedido (idPedido)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;
USE ecommerce_db;

CREATE TABLE IF NOT EXISTS produtos_por_vendedor (
    idProduto INT NOT NULL,
    idTerceiroVendedor INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    PRIMARY KEY (idProduto, idTerceiroVendedor),
    CONSTRAINT fk_pv_produto
        FOREIGN KEY (idProduto)
        REFERENCES produto (idProduto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pv_vendedor
        FOREIGN KEY (idTerceiroVendedor)
        REFERENCES terceiro_vendedor (idTerceiroVendedor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_pv_quantidade
        CHECK (quantidade >= 0)
) ENGINE = InnoDB;

USE ecommerce_db;

CREATE TABLE IF NOT EXISTS produto_has_fornecedor (
    idProduto INT NOT NULL,
    idFornecedor INT NOT NULL,
    PRIMARY KEY (idProduto, idFornecedor),
    CONSTRAINT fk_phf_produto
        FOREIGN KEY (idProduto)
        REFERENCES produto (idProduto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_phf_fornecedor
        FOREIGN KEY (idFornecedor)
        REFERENCES fornecedor (idFornecedor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

USE ecommerce_db;

CREATE TABLE IF NOT EXISTS produto_has_estoque (
    idProduto INT NOT NULL,
    idEstoque INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    statusEstoque ENUM(
        'Disponivel',
        'Reservado',
        'Indisponivel'
    ) NOT NULL DEFAULT 'Disponivel',
    PRIMARY KEY (idProduto, idEstoque),
    CONSTRAINT fk_phe_produto
        FOREIGN KEY (idProduto)
        REFERENCES produto (idProduto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_phe_estoque
        FOREIGN KEY (idEstoque)
        REFERENCES estoque (idEstoque)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT chk_phe_quantidade
        CHECK (quantidade >= 0)
) ENGINE = InnoDB;
show tables;

USE ecommerce_db;

SELECT
    TABLE_NAME AS tabela,
    COLUMN_NAME AS coluna,
    CONSTRAINT_NAME AS restricao,
    REFERENCED_TABLE_NAME AS tabela_referenciada,
    REFERENCED_COLUMN_NAME AS coluna_referenciada
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'ecommerce_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

USE ecommerce_db;

SHOW TABLES;

USE ecommerce_db;

DESCRIBE cliente;
DESCRIBE cliente_pf;
DESCRIBE cliente_pj;
DESCRIBE produto;
DESCRIBE pedido;
DESCRIBE item_pedido;
DESCRIBE pagamento;
DESCRIBE entrega;

USE ecommerce_db;

DESCRIBE produtos_por_vendedor;
DESCRIBE produto_has_fornecedor;
DESCRIBE produto_has_estoque;
DESCRIBE fornecedor;

USE ecommerce_db;

SHOW CREATE TABLE produtos_por_vendedor;

SHOW CREATE TABLE produto_has_fornecedor;

SHOW CREATE TABLE produto_has_estoque;

SHOW CREATE TABLE pagamento;

SHOW CREATE TABLE entrega;

SELECT
    'cliente' AS tabela,
    COUNT(*) AS total
FROM cliente

UNION ALL

SELECT
    'produto',
    COUNT(*)
FROM produto

UNION ALL

SELECT
    'pedido',
    COUNT(*)
FROM pedido;

USE ecommerce_db;

INSERT INTO cliente (tipoCliente)
VALUES
    ('PF'),
    ('PF'),
    ('PF'),
    ('PJ'),
    ('PJ');

SELECT * FROM cliente;

USE ecommerce_db;

INSERT INTO cliente_pf
    (idCliente, Pnome, Mnome, Unome, CPF, endereco)
VALUES
    (1, 'Ana', 'M', 'Silva', '12345678901', 'Rua das Flores, 10'),
    (2, 'Bruno', 'A', 'Costa', '23456789012', 'Avenida Central, 25'),
    (3, 'Carla', NULL, 'Santos', '34567890123', 'Rua do Comercio, 8');

SELECT * FROM cliente_pf;

INSERT INTO cliente_pj
    (idCliente, razaoSocial, CNPJ)
VALUES
    (4, 'Braga Tech Comercio Digital Lda', '45678901234567'),
    (5, 'Norte Distribuicao Online Lda', '56789012345678');
SELECT * FROM cliente_pj;

INSERT INTO produto (nome, categoria, descricao, valor)
VALUES
    ('Portatil Lenovo IdeaPad', 'Eletronicos', 'Portatil para trabalho e estudo', 649.99),
    ('Rato Logitech M185', 'Acessorios', 'Rato sem fios', 19.99),
    ('Teclado mecanico Redragon', 'Acessorios', 'Teclado mecanico para computador', 59.90),
    ('Monitor Samsung 24 polegadas', 'Eletronicos', 'Monitor Full HD', 149.90),
    ('Cadeira ergonomica Office', 'Moveis', 'Cadeira para escritorio', 189.00),
    ('Auscultadores JBL', 'Audio', 'Auscultadores com ligacao Bluetooth', 79.99);
    

SELECT * from produto;
SHOW COLUMNS FROM produto LIKE 'categoria';    

ALTER TABLE produto
MODIFY COLUMN categoria ENUM(
    'Eletronico',
    'Acessorios',
    'Moveis',
    'Audio',
    'Vestimenta',
    'Brinquedos',
    'Alimentos'
) NULL;

SHOW COLUMNS FROM produto LIKE 'categoria';

INSERT INTO produto (nome, categoria, descricao, valor)
VALUES
    ('Portatil Lenovo IdeaPad', 'Eletronico', 'Portatil para trabalho e estudo', 649.99),
    ('Rato Logitech M185', 'Eletronico', 'Rato sem fios', 19.99),
    ('Teclado mecanico Redragon', 'Eletronico', 'Teclado mecanico para computador', 59.90),
    ('Monitor Samsung 24 polegadas', 'Eletronico', 'Monitor Full HD', 149.90),
    ('Cadeira ergonomica Office', 'Vestimenta', 'Cadeira para escritorio', 189.00),
    ('Auscultadores JBL', 'Eletronico', 'Auscultadores com ligacao Bluetooth', 79.99);
    
SELECT idProduto, nome, categoria, valor
FROM produto
ORDER BY idProduto;


UPDATE produto
SET categoria = 'Moveis'
WHERE idProduto = 5;

INSERT INTO fornecedor (razaoSocial, CNPJ)
VALUES
    ('Tech Distribuicao Lda', '12345678000195'),
    ('Informatica Norte Lda', '23456789000196'),
    ('Comercial Digital Lda', '34567890000197');

SELECT * FROM fornecedor;

INSERT INTO produto_has_fornecedor (idProduto, idFornecedor)
VALUES
    (1, 1),
    (1, 2),
    (2, 2),
    (3, 2),
    (4, 1),
    (5, 3),
    (6, 3);

SELECT
    p.idProduto,
    p.nome AS produto,
    f.razaoSocial AS fornecedor
FROM produto_has_fornecedor pf
INNER JOIN produto p
    ON pf.idProduto = p.idProduto
INNER JOIN fornecedor f
    ON pf.idFornecedor = f.idFornecedor
ORDER BY p.idProduto, f.idFornecedor;

USE ecommerce_db;

INSERT INTO terceiro_vendedor
    (RazaoSocial, Local, NomeFantasia, Endereco)
VALUES
    ('Marketplace Norte Lda', 'Braga', 'Norte Tech', 'Rua Central, 15'),
    ('Comercio Digital Porto Lda', 'Porto', 'Digital Porto', 'Avenida da Boavista, 100'),
    ('Distribuicao Minho Lda', 'Guimaraes', 'Minho Store', 'Rua de Santo Antonio, 20');

SELECT * FROM terceiro_vendedor;


USE ecommerce_db;

INSERT INTO produtos_por_vendedor
    (idProduto, idTerceiroVendedor, quantidade)
VALUES
    (1, 1, 10),
    (2, 1, 25),
    (4, 1, 8),
    (1, 2, 5),
    (3, 2, 12),
    (6, 2, 15),
    (5, 3, 4),
    (2, 3, 0);

SELECT
    p.nome AS produto,
    tv.NomeFantasia AS vendedor,
    pv.quantidade
FROM produtos_por_vendedor pv
INNER JOIN produto p
    ON pv.idProduto = p.idProduto
INNER JOIN terceiro_vendedor tv
    ON pv.idTerceiroVendedor = tv.idTerceiroVendedor
ORDER BY p.idProduto, tv.idTerceiroVendedor;

USE ecommerce_db;

INSERT INTO estoque (localEstoque)
VALUES
    ('Armazem Braga'),
    ('Armazem Porto'),
    ('Armazem Guimaraes');

SELECT * FROM estoque;

USE ecommerce_db;

INSERT INTO produto_has_estoque
    (idProduto, idEstoque, quantidade, statusEstoque)
VALUES
    (1, 1, 12, 'Disponivel'),
    (1, 2, 5,  'Disponivel'),
    (2, 1, 20, 'Disponivel'),
    (2, 3, 0,  'Indisponivel'),
    (3, 2, 15, 'Disponivel'),
    (4, 1, 8,  'Disponivel'),
    (5, 3, 6,  'Disponivel'),
    (6, 2, 10, 'Disponivel');
    
    SELECT
    p.idProduto,
    p.nome AS produto,
    e.localEstoque AS armazem,
    pe.quantidade,
    pe.statusEstoque
FROM produto_has_estoque pe
INNER JOIN produto p
    ON pe.idProduto = p.idProduto
INNER JOIN estoque e
    ON pe.idEstoque = e.idEstoque
ORDER BY p.idProduto, e.idEstoque;

USE ecommerce_db;

INSERT INTO pedido
    (idCliente, statusPedido, descricao, frete)
VALUES
    (1, 'Entregue', 'Compra de portatil e rato', 5.00),
    (2, 'Em processamento', 'Compra de teclado mecanico', 3.50),
    (3, 'Em transporte', 'Compra de monitor', 7.00),
    (4, 'Entregue', 'Compra de cadeira ergonomica', 6.00),
    (5, 'Em processamento', 'Compra de auscultadores', 4.00);
    
    SELECT
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    p.descricao,
    p.frete
FROM pedido p
ORDER BY p.idPedido;


USE ecommerce_db;

INSERT INTO item_pedido
    (idPedido, idProduto, quantidade, precoUnitario)
VALUES
    (1, 1, 1, 649.99),
    (1, 2, 1, 19.99),
    (2, 3, 2, 59.90),
    (3, 4, 1, 149.90),
    (4, 5, 1, 189.00),
    (5, 6, 2, 79.99);


SELECT
    ip.idPedido,
    p.nome AS produto,
    ip.quantidade,
    ip.precoUnitario,
    ip.quantidade * ip.precoUnitario AS subtotal
FROM item_pedido ip
INNER JOIN produto p
    ON ip.idProduto = p.idProduto
ORDER BY ip.idPedido, p.idProduto;

USE ecommerce_db;

SELECT
    pe.idPedido,
    pe.idCliente,
    pe.statusPedido,
    SUM(ip.quantidade * ip.precoUnitario) AS subtotalProdutos,
    pe.frete,
    SUM(ip.quantidade * ip.precoUnitario) + pe.frete AS totalPedido
FROM pedido pe
INNER JOIN item_pedido ip
    ON pe.idPedido = ip.idPedido
GROUP BY
    pe.idPedido,
    pe.idCliente,
    pe.statusPedido,
    pe.frete
ORDER BY pe.idPedido;

SELECT * FROM pagamento;

INSERT INTO pagamento
    (idPedido, formaPagamento, valor)
VALUES
    (1, 'MB Way', 674.98),
    (2, 'Pix', 123.30),
    (3, 'Cartao de credito', 156.90),
    (4, 'Transferencia bancaria', 195.00),
    (5, 'Multibanco', 163.98);
    
SELECT * FROM pagamento
order by idPedido;

USE ecommerce_db;

INSERT INTO entrega
    (idPedido, statusEntrega, codigoRastreio, dataEnvio, dataEntrega)
VALUES
    (1, 'Entregue', 'PT202610280001', '2026-10-25 10:00:00', '2026-10-27 15:30:00'),
    (2, 'Em preparação', NULL, NULL, NULL),
    (3, 'Em transporte', 'PT202610280003', '2026-10-28 09:00:00', NULL),
    (4, 'Entregue', 'PT202610280004', '2026-10-24 11:00:00', '2026-10-26 16:00:00'),
    (5, 'Em preparação', NULL, NULL, NULL);
    
    select * from entrega
    order by idPedido;
    
    USE ecommerce_db;

SELECT
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    p.descricao,
    p.frete,
    pg.formaPagamento,
    pg.valor AS valorPago,
    e.statusEntrega,
    e.codigoRastreio
FROM pedido p
INNER JOIN pagamento pg
    ON p.idPedido = pg.idPedido
INNER JOIN entrega e
    ON p.idPedido = e.idPedido
ORDER BY p.idPedido;

USE ecommerce_db;

SELECT
    idPedido,
    COUNT(*) AS quantidadePagamentos,
    SUM(valor) AS totalPago,
    GROUP_CONCAT(
        formaPagamento
        ORDER BY formaPagamento
        SEPARATOR ', '
    ) AS formasPagamento
FROM pagamento
GROUP BY idPedido
ORDER BY idPedido;

USE ecommerce_db;

SELECT
    c.idCliente,
    COUNT(p.idPedido) AS quantidadePedidos
FROM cliente c
INNER JOIN pedido p
    ON c.idCliente = p.idCliente
GROUP BY c.idCliente
HAVING COUNT(p.idPedido) > 1
ORDER BY quantidadePedidos DESC;

USE ecommerce_db;

SELECT
    c.idCliente,
    c.tipoCliente,
    CASE
        WHEN pf.idCliente IS NOT NULL
         AND pj.idCliente IS NOT NULL
            THEN 'ERRO: PF e PJ simultaneamente'
        WHEN pf.idCliente IS NOT NULL
            THEN 'PF registado'
        WHEN pj.idCliente IS NOT NULL
            THEN 'PJ registado'
        ELSE 'SEM REGISTO PF/PJ'
    END AS validacaoCliente
FROM cliente c
LEFT JOIN cliente_pf pf
    ON c.idCliente = pf.idCliente
LEFT JOIN cliente_pj pj
    ON c.idCliente = pj.idCliente
ORDER BY c.idCliente;

USE ecommerce_db;

SELECT
    tv.idTerceiroVendedor,
    tv.RazaoSocial AS vendedor,
    f.idFornecedor,
    f.razaoSocial AS fornecedor
FROM terceiro_vendedor tv
INNER JOIN fornecedor f
    ON LOWER(TRIM(tv.RazaoSocial)) = LOWER(TRIM(f.razaoSocial))
ORDER BY tv.RazaoSocial;


SELECT
    p.idProduto,
    p.nome AS produto,
    f.razaoSocial AS fornecedor,
    e.localEstoque AS armazem,
    pe.quantidade,
    pe.statusEstoque
FROM produto p
INNER JOIN produto_has_fornecedor pf
    ON p.idProduto = pf.idProduto
INNER JOIN fornecedor f
    ON pf.idFornecedor = f.idFornecedor
LEFT JOIN produto_has_estoque pe
    ON p.idProduto = pe.idProduto
LEFT JOIN estoque e
    ON pe.idEstoque = e.idEstoque
ORDER BY p.nome, f.razaoSocial, e.localEstoque;

USE ecommerce_db;

SELECT
    tv.idTerceiroVendedor,
    tv.RazaoSocial AS vendedor,
    f.idFornecedor,
    f.razaoSocial AS fornecedor
FROM terceiro_vendedor tv
INNER JOIN fornecedor f
    ON LOWER(TRIM(tv.RazaoSocial)) = LOWER(TRIM(f.razaoSocial))
ORDER BY tv.RazaoSocial;

SELECT
	idTerceiroVendedor,
	RazaoSocial,
    NomeFantasia
FROM terceiro_vendedor
ORDER BY RazaoSocial;

USE ecommerce_db;

SELECT
    idFornecedor,
    razaoSocial,
    CNPJ
FROM fornecedor
ORDER BY razaoSocial;

USE ecommerce_db;

SELECT
    tv.idTerceiroVendedor,
    tv.RazaoSocial AS vendedor,
    CASE
        WHEN f.idFornecedor IS NOT NULL THEN 'Sim'
        ELSE 'Nao'
    END AS tambemEhFornecedor
FROM terceiro_vendedor tv
LEFT JOIN fornecedor f
    ON LOWER(TRIM(tv.RazaoSocial)) = LOWER(TRIM(f.razaoSocial))
ORDER BY tv.RazaoSocial;

USE ecommerce_db;

SELECT
    c.idCliente,
    c.tipoCliente,
    COUNT(DISTINCT p.idPedido) AS quantidadePedidos,
    COALESCE(SUM(ip.quantidade * ip.precoUnitario), 0) AS totalProdutos,
    COALESCE(SUM(DISTINCT p.frete), 0) AS totalFrete
FROM cliente c
LEFT JOIN pedido p
    ON c.idCliente = p.idCliente
LEFT JOIN item_pedido ip
    ON p.idPedido = ip.idPedido
GROUP BY
    c.idCliente,
    c.tipoCliente
ORDER BY quantidadePedidos DESC, c.idCliente;

USE ecommerce_db;

SELECT
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    SUM(ip.quantidade * ip.precoUnitario) AS subtotalProdutos,
    p.frete,
    SUM(ip.quantidade * ip.precoUnitario) + p.frete AS totalPedido
FROM pedido p
INNER JOIN item_pedido ip
    ON p.idPedido = ip.idPedido
GROUP BY
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    p.frete
HAVING SUM(ip.quantidade * ip.precoUnitario) + p.frete > 200
ORDER BY totalPedido DESC;

SELECT
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    COUNT(ip.idProduto) AS quantidadeItens,
    COALESCE(SUM(ip.quantidade * ip.precoUnitario), 0) AS subtotalProdutos,
    p.frete,
    COALESCE(SUM(ip.quantidade * ip.precoUnitario), 0)
        + p.frete AS totalPedido
FROM pedido p
LEFT JOIN item_pedido ip
    ON p.idPedido = ip.idPedido
GROUP BY
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    p.frete
ORDER BY p.idPedido;

SELECT
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    SUM(ip.quantidade * ip.precoUnitario) AS subtotalProdutos,
    p.frete,
    SUM(ip.quantidade * ip.precoUnitario) + p.frete AS totalPedido
FROM pedido p
INNER JOIN item_pedido ip
    ON p.idPedido = ip.idPedido
GROUP BY
    p.idPedido,
    p.idCliente,
    p.statusPedido,
    p.frete
HAVING SUM(ip.quantidade * ip.precoUnitario) + p.frete > 200
ORDER BY totalPedido DESC;

SELECT
    pr.idProduto,
    pr.nome AS produto,
    SUM(ip.quantidade) AS quantidadeVendida,
    SUM(ip.quantidade * ip.precoUnitario) AS valorTotalVendido
FROM produto pr
INNER JOIN item_pedido ip
    ON pr.idProduto = ip.idProduto
INNER JOIN pedido p
    ON ip.idPedido = p.idPedido
WHERE p.statusPedido <> 'Cancelado'
GROUP BY
    pr.idProduto,
    pr.nome
ORDER BY quantidadeVendida DESC, valorTotalVendido DESC;


SELECT
    p.statusPedido,
    COUNT(DISTINCT p.idPedido) AS quantidadePedidos,
    SUM(ip.quantidade * ip.precoUnitario) AS subtotalProdutos,
    SUM(DISTINCT p.frete) AS totalFrete
FROM pedido p
INNER JOIN item_pedido ip
    ON p.idPedido = ip.idPedido
GROUP BY p.statusPedido
ORDER BY quantidadePedidos DESC;

USE ecommerce_db;

SELECT
    resumo.statusPedido,
    COUNT(*) AS quantidadePedidos,
    SUM(resumo.subtotalProdutos) AS subtotalProdutos,
    SUM(resumo.frete) AS totalFrete,
    SUM(resumo.subtotalProdutos + resumo.frete) AS valorTotalPedidos
FROM (
    SELECT
        p.idPedido,
        p.statusPedido,
        p.frete,
        COALESCE(
            SUM(ip.quantidade * ip.precoUnitario), 0
        ) AS subtotalProdutos
    FROM pedido p
    LEFT JOIN item_pedido ip
        ON p.idPedido = ip.idPedido
    GROUP BY
        p.idPedido,
        p.statusPedido,
        p.frete
) AS resumo
GROUP BY resumo.statusPedido
ORDER BY valorTotalPedidos DESC;

show create table entrega;

USE ecommerce_db;

SELECT
    COUNT(*) AS totalClientes
FROM cliente;

SELECT
    COUNT(*) AS totalProdutos,
    ROUND(AVG(valor), 2) AS precoMedio,
    MIN(valor) AS menorPreco,
    MAX(valor) AS maiorPreco
FROM produto;

USE ecommerce_db;

SELECT
    p.idPedido,
    p.statusPedido
FROM pedido p
LEFT JOIN item_pedido ip
    ON p.idPedido = ip.idPedido
WHERE ip.idPedido IS NULL;


SELECT
    ip.idPedido,
    ip.idProduto,
    ip.quantidade,
    ip.precoUnitario
FROM item_pedido ip
LEFT JOIN produto pr
    ON ip.idProduto = pr.idProduto
WHERE pr.idProduto IS NULL;

SELECT
    pg.idPagamento,
    pg.idPedido,
    pg.formaPagamento,
    pg.valor
FROM pagamento pg
LEFT JOIN pedido p
    ON pg.idPedido = p.idPedido
WHERE p.idPedido IS NULL;

SELECT
    e.idEntrega,
    e.idPedido,
    e.statusEntrega,
    e.codigoRastreio
FROM entrega e
LEFT JOIN pedido p
    ON e.idPedido = p.idPedido
WHERE p.idPedido IS NULL;

SELECT
    p.idPedido,
    p.idCliente,
    p.statusPedido
FROM pedido p
LEFT JOIN cliente c
    ON p.idCliente = c.idCliente
WHERE c.idCliente IS NULL;

SELECT
    statusEntrega,
    COUNT(*) AS quantidadeEntregas
FROM entrega
GROUP BY statusEntrega
ORDER BY quantidadeEntregas DESC;

SELECT
    p.idPedido,
    p.idCliente,
    p.statusPedido
FROM pedido p
LEFT JOIN cliente c
    ON p.idCliente = c.idCliente
WHERE c.idCliente IS NULL;

SELECT
    c.idCliente,
    c.tipoCliente
FROM cliente c
LEFT JOIN cliente_pf pf
    ON c.idCliente = pf.idCliente
LEFT JOIN cliente_pj pj
    ON c.idCliente = pj.idCliente
WHERE
    (c.tipoCliente = 'PF' AND pf.idCliente IS NULL)
    OR
    (c.tipoCliente = 'PJ' AND pj.idCliente IS NULL);

SELECT
    c.idCliente,
    c.tipoCliente
FROM cliente c
INNER JOIN cliente_pf pf
    ON c.idCliente = pf.idCliente
INNER JOIN cliente_pj pj
    ON c.idCliente = pj.idCliente;

SELECT
    c.idCliente,
    c.tipoCliente
FROM cliente c
INNER JOIN cliente_pf pf
    ON c.idCliente = pf.idCliente
INNER JOIN cliente_pj pj
    ON c.idCliente = pj.idCliente;
    
SHOW CREATE TABLE pagamento;    

USE ecommerce_db;

SELECT
    c.idCliente,
    c.tipoCliente,
    COUNT(DISTINCT p.idPedido) AS quantidadePedidos,
    COALESCE(SUM(pedido_totais.totalPedido), 0) AS valorTotalPedidos
FROM cliente c
LEFT JOIN pedido p
    ON c.idCliente = p.idCliente
LEFT JOIN (
    SELECT
        p2.idPedido,
        SUM(ip.quantidade * ip.precoUnitario) + p2.frete AS totalPedido
    FROM pedido p2
    INNER JOIN item_pedido ip
        ON p2.idPedido = ip.idPedido
    GROUP BY p2.idPedido, p2.frete
) AS pedido_totais
    ON p.idPedido = pedido_totais.idPedido
GROUP BY
    c.idCliente,
    c.tipoCliente
ORDER BY valorTotalPedidos DESC;
