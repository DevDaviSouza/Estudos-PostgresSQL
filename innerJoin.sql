create database db_escola_informatica;

use db_escola_informatica;

-- Tabela de Alunos
CREATE TABLE alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento DATE,
    telefone VARCHAR(15)
);

-- Tabela de Cursos
CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    carga_horaria INT NOT NULL
);

-- Tabela de Instrutores
CREATE TABLE instrutores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    especialidade VARCHAR(100)
);

-- Tabela de Matrículas
CREATE TABLE matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT,
    curso_id INT,
    data_matricula DATE NOT NULL,
    status ENUM('Ativo', 'Finalizado', 'Cancelado') NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- Tabela de Instrutores_Cursos (associando instrutores aos cursos)
CREATE TABLE instrutores_cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    curso_id INT,
    instrutor_id INT,
    data_inicio DATE,
    data_fim DATE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id),
    FOREIGN KEY (instrutor_id) REFERENCES instrutores(id)
);

-- Inserir dados na tabela de Alunos
INSERT INTO alunos (nome, email, data_nascimento, telefone)
VALUES 
('João Silva', 'joao.silva@example.com', '2000-05-20', '123456789'),
('Maria Oliveira', 'maria.oliveira@example.com', '1995-09-12', '987654321'),
('Carlos Santos', 'carlos.santos@example.com', '1998-03-15', '456123789');

-- Inserir dados na tabela de Cursos
INSERT INTO cursos (nome, descricao, carga_horaria)
VALUES 
('Introdução à Programação', 'Curso básico para aprender lógica de programação.', 40),
('Desenvolvimento Web', 'Curso completo sobre front-end e back-end.', 100),
('Banco de Dados', 'Curso sobre modelagem e SQL.', 60);

-- Inserir dados na tabela de Instrutores
INSERT INTO instrutores (nome, email, especialidade)
VALUES 
('Ana Souza', 'ana.souza@example.com', 'Desenvolvimento Web'),
('Paulo Mendes', 'paulo.mendes@example.com', 'Banco de Dados'),
('Fernanda Costa', 'fernanda.costa@example.com', 'Lógica de Programação');

-- Inserir dados na tabela de Matrículas
INSERT INTO matriculas (aluno_id, curso_id, data_matricula, status)
VALUES 
(1, 1, '2025-01-15', 'Ativo'),
(2, 2, '2025-01-10', 'Ativo'),
(3, 3, '2025-01-12', 'Ativo'),
(1, 2, '2025-01-18', 'Ativo');

-- Inserir dados na tabela de Instrutores_Cursos
INSERT INTO instrutores_cursos (curso_id, instrutor_id, data_inicio, data_fim)
VALUES 
(1, 3, '2025-01-01', '2025-06-30'),
(2, 1, '2025-01-01', '2025-06-30'),
(3, 2, '2025-01-01', '2025-06-30');

-- Questão 1: Quais alunos estão matriculados em cursos e quem são os instrutores responsáveis por cada curso?

SELECT a.nome AS Aluno, c.nome AS Nome_curso, i.nome AS Instrutor
FROM matriculas m
INNER JOIN alunos a ON m.aluno_id = a.id
INNER JOIN cursos c ON c.id = m.curso_id
INNER JOIN instrutores_cursos ic ON ic.curso_id = c.id
INNER JOIN instrutores i ON ic.instrutor_id = i.id;

-- Questão 2: Quais cursos foram ministrados por cada instrutor?

SELECT c.id AS id_curso, c.nome AS nome_curso, i.nome AS instrutor
FROM instrutores i
INNER JOIN instrutores_cursos ic ON ic.instrutor_id = i.id
INNER JOIN cursos c ON ic.curso_id = c.id; 

-- Questão 3: Quantos alunos estão matriculados em cada curso? 

SELECT c.nome AS nome_curso, COUNT(m.aluno_id) AS qtd_alunos
FROM matriculas m
INNER JOIN cursos c ON m.curso_id = c.id
GROUP BY c.nome;

-- Questão 4: Quais cursos têm instrutores associados e qual a data de início e fim de cada contrato de instrutor?

SELECT c.nome AS curso, i.nome AS instrutor, ic.data_inicio AS inicio_curso, ic.data_fim AS fim_curso
FROM cursos c 
INNER JOIN instrutores_cursos ic ON c.id = ic.curso_id
INNER JOIN instrutores i ON i.id = ic.instrutor_id
