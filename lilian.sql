use aula_db_exemplos;

-- 1
select titulo from livros;

-- 2
select nome from autores where nascimento < '1900-01-01';

-- 3
select livros.titulo, autores.nome
from livros 
inner join autores on livros.autor_id = autores.id
where autores.nome = 'J.K. Rowling';