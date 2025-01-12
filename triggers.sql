CREATE TABLE estoque(
	id			SERIAL PRIMARY KEY,
	nome		TEXT,
	quantidade	INT
);

CREATE TABLE historico_estoque(
	id 						SERIAL PRIMARY KEY,
	nome					TEXT,
	quantidade_antiga		INT,
	quantidade_nova			INT,
);

ALTER TABLE historico_estoque
ADD data_alteracao			TIMESTAMP DEFAULT current_timestamp;

CREATE OR REPLACE FUNCTION auditoria_estoque()
RETURNS trigger AS $$
BEGIN
	INSERT INTO historico_estoque(nome, quantidade_antiga, quantidade_nova)
						   VALUES(OLD.nome, OLD.quantidade, NEW.quantidade);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_auditoria_estoque
AFTER UPDATE
ON estoque
FOR EACH ROW 
WHEN (OLD.quantidade IS DISTINCT FROM NEW.quantidade)
EXECUTE FUNCTION auditoria_estoque();

INSERT INTO estoque(nome, quantidade)
			 VALUES('sorvete', 3);

SELECT * FROM estoque;

UPDATE estoque SET nome = 'chocolate' WHERE id = 1;

SELECT * FROM historico_estoque;
