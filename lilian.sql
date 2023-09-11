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

-- 4
select alunos.nome, matriculas.curso
from alunos
inner join matriculas on alunos.id = matriculas.aluno_id
where matriculas.curso = 'Engenharia de Software';

-- 5
select produto, SUM(receita) as total_receita
from vendas
group by produto;

-- 6
select autores.nome as autor, COUNT(livros.id) as numero_de_livros
from autores
left join livros on autores.id = livros.autor_id
group by autores.id
order by autores.id;