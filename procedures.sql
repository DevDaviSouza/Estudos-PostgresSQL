-- Criacao de procedures

CREATE TABLE clientes(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100),
	email VARCHAR(100),
	idade INT
);

CREATE OR REPLACE PROCEDURE inserir_cliente(
p_nome 	VARCHAR,
p_email VARCHAR,
p_idade	INT
)

LANGUAGE plpgsql

AS $$
BEGIN
	INSERT INTO clientes(nome, email, idade)
	VALUES(p_nome, p_email, p_idade);
END;
$$;

CALL inserir_cliente('João', 'joao@teste.com', 10);

SELECT * FROM clientes;

CREATE OR REPLACE PROCEDURE atualizar_idade();

LANGUAGE plpgsql

AS $$
DECLARE r RECORD;
BEGIN
	FOR r  IN SELECT id, idade FROM clientes LOOP
		IF r.idade < 18 THEN
			UPDATE clientes
			SET idade = 18
			WHERE id = r.id;
		END IF;
	END LOOP;
END;
$$;

CALL atualizar_idade();

CREATE OR REPLACE PROCEDURE buscar_cliente(p_id INT)

LANGUAGE plpgsql
AS $$
DECLARE r RECORD;
BEGIN
	SELECT id, nome, idade INTO r FROM clientes
	WHERE id = p_id;

	IF r.id IS NOT NULL THEN
		RAISE NOTICE 'Cliente encontrado: ID: %, nome: %, idade %', r.id, r.nome, r.idade;
	ELSE 
		RAISE NOTICE 'Cliente com ID % não encontrado', p_id;
		END IF;
END;
$$;

CALL buscar_cliente(1);

CREATE OR REPLACE FUNCTION total_clientes1()

RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE total INT;
BEGIN
	SELECT COUNT(*) INTO total FROM clientes;
	RETURN total;
END;
$$;

select total_clientes1();


CREATE OR REPLACE PROCEDURE cadastra_cliente(p_nome VARCHAR, p_email VARCHAR , p_idade INT)

LANGUAGE plpgsql
AS $$
DECLARE email_existe BOOLEAN;
BEGIN
	SELECT EXISTS(
		SELECT 1
		FROM clientes
		WHERE email = p_email
	) INTO email_existe;

	IF email_existe THEN
		RAISE EXCEPTION 'O email "%" já está cadastrado.', p_email;
	ELSE
		INSERT INTO clientes(nome, email, idade)
					  VALUES(p_nome, p_email, p_idade);
	END IF;
END;
$$;

CALL cadastra_cliente('davi2', 'davi@teste.com', 20);

SELECT  * FROM clientes;



-- Triggers

CREATE TABLE historico_clientes(
	id SERIAL PRIMARY KEY,
	cliente_id INT,
	nome_antigo TEXT,
	nome_novo TEXT,
	data_modificacao TIMESTAMP DEFAULT current_timestamp
);

CREATE OR REPLACE FUNCTION auditar_atualizacao_clientes()
RETURNS trigger AS $$
BEGIN
	INSERT INTO historico_clientes(cliente_id, nome_antigo, nome_novo)
	VALUES(OLD.id, OLD.nome, NEW.nome);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auditoria_clientes
AFTER UPDATE
ON clientes
FOR EACH ROW
EXECUTE FUNCTION auditar_atualizacao_clientes();

UPDATE clientes SET nome = 'testando' WHERE id = 1;

select * from historico_clientes;





