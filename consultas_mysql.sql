CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Telefone VARCHAR(15),
    Cidade VARCHAR(50)
);

INSERT INTO Clientes(Nome, Email, Telefone, Cidade)
			  VALUES("Davi", "davi.123@gmail.com", "11954325676", "São Paulo");

CREATE TABLE Produtos (
    ProdutoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    Estoque INT DEFAULT 0
);

CREATE TABLE Pedidos (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT,
    DataPedido DATE NOT NULL,
    Total DECIMAL(10, 2),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

INSERT INTO Pedidos(ClienteID, DataPedido, Total)
			 VALUES(1, "2024-12-01", 250.00);

CREATE TABLE ItensPedidos (
    ItemPedidoID INT AUTO_INCREMENT PRIMARY KEY,
    PedidoID INT,
    ProdutoID INT,
    Quantidade INT NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

-- Exemplo de Inner Join que mostra o id do pedido, o id do cliente e seu nome baseado no cliente ID igual das duas tabelas.
SELECT p.PedidoID, c.ClienteID, c.Nome 
	FROM Pedidos p 
	INNER JOIN Clientes c ON p.ClienteID = c.ClienteID;

-- ex1
-- Lista o nome do cliente e seus pedidos
SELECT c.Nome, p.PedidoID 
	FROM Clientes c 
	INNER JOIN Pedidos p ON p.ClienteID = c.ClienteID;

-- ex2 
-- Lista o número dos pedidos e o nome dos itens vendidos
SELECT ip.PedidoID, pr.Nome 
	FROM ItensPedidos ip 
	INNER JOIN Pedidos p ON ip.PedidoID = p.PedidoID
    INNER JOIN Produtos pr ON ip.ProdutoID = pr.ProdutoID;
    
-- ex3 
-- Lista o nome do cliente, os produtos que ele comprou e a quantidade
SELECT C.Nome, pr.Nome, ip.Quantidade
	FROM Pedidos p
    INNER JOIN ItensPedidos ip ON p.PedidoID = ip.PedidoID
    INNER JOIN Produtos pr ON pr.ProdutoID = ip.ProdutoID
    INNER JOIN Clientes c ON c.ClienteID = p.ClienteID;
     
-- ex4
-- Lista o total vendido de cada produto
SELECT pr.Nome AS Produto, SUM(ip.Quantidade) AS Total_Vendido
FROM Produtos pr
INNER JOIN ItensPedidos ip ON pr.ProdutoID = ip.ProdutoID
GROUP BY pr.Nome;

-- ex5
-- Lista o total gasto por cliente
SELECT c.Nome AS Cliente, SUM(ip.preco * ip.quantidade) AS Total_Gasto 
FROM Clientes c 
INNER JOIN Pedidos p ON c.ClienteID = p.ClienteID
INNER JOIN ItensPedidos ip ON ip.PedidoID = p.PedidoID
GROUP BY c.Nome;

-- ex6
-- lista os pedidos com mais de um item
SELECT p.PedidoID 
FROM Pedidos p
INNER JOIN ItensPedidos ip ON ip.PedidoID = p.PedidoID
GROUP BY p.PedidoID
HAVING COUNT(ip.PedidoID) > 1;

-- ex 7 
-- Lista os produtos que não tiveram nenhuma venda
SELECT pr.Nome AS Produto
FROM Produtos pr
LEFT JOIN ItensPedidos ip ON pr.ProdutoID = ip.ProdutoID
where ip.ProdutoID is null;	

-- ex 8
-- lista todos os clientes com mais de um pedido 
SELECT c.Nome AS Cliente
FROM Clientes c 
INNER JOIN Pedidos p ON c.ClienteID = p.ClienteID
GROUP BY c.Nome
HAVING COUNT(p.PedidoID) > 1;
