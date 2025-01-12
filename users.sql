-- cria um novo user/grupo
CREATE ROLE analista_dados WITH LOGIN PASSWORD 'senha';

-- cria um novo usuário com permissao total no banco, junto com permissao para criar outros usuarios
CREATE ROLE admin_db WITH SUPERUSER CREATEDB CREATEROLE LOGIN PASSWORD 'admin';

-- libera ao analista de dados permissao para fazer selects e inserts na tabela estoque
GRANT SELECT, INSERT ON estoque TO analista_dados;

-- revoga a permissao de inserts
REVOKE INSERT ON estoque FROM analista_dados;

-- liberacao de permissao para conectar em banco de dados
GRANT CONNECT ON DATABASE estoque TO analista_dados;

-- remocao de permissao para conectar ao banco de dados
REVOKE CONNECT ON DATABASE estoque TO analista_dados;

-- libera acesso a schemas(modularização por tema)
GRANT USAGE ON SCHEMA public TO admin_db;

-- permissao para usar select nas colunas dentro dos parenteses
GRANT SELECT(nome, quantidade) ON estoque TO admin_db;

-- habilita o nivel de linha para protecao da tabela
ALTER TABLE estoque ENABLE ROW LEVEL SECURITY;

-- criacao de uma politica de protecao de linhas
CREATE POLICY estoque_protegido ON estoque 
	FOR SELECT USING (quantidade > 0);
