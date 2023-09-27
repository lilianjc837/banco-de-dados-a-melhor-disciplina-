DELIMITER // 
create procedure sp_ListarAutores()
begin
    select * from autor;
end;
//
DELIMITER ;

call sp_ListarAutores();

-- 2
delimiter //
create procedure sp_livros_por_categoria(in categoria_nome varchar(100))
begin
    select livro.titulo
    from livro
    inner join categoria on livro.categoria_id = categoria.categoria_id
    where categoria.nome = categoria_nome;
end;
//
delimiter ;

call sp_livros_por_categoria('Romance');
call sp_livros_por_categoria('Ficção científica');

-- 3
delimiter //
create procedure sp_contar_livros_por_categoria(in categoria_nome varchar(100), out total_livros int)
begin
    select count(*) into total_livros
    from livro
    inner join categoria on livro.categoria_id = categoria.categoria_id
    where categoria.nome = categoria_nome;
end;
//
delimiter ;
call sp_contar_livros_por_categoria('História', @total);
select @total;

-- 4
delimiter //
create procedure sp_verificar_livros_categoria(in categoria_nome varchar(100), out categoria_possui_livros boolean)
begin
    declare contador int;
    select count(*) into contador
    from livro
    inner join categoria on livro.categoria_id = categoria.categoria_id
    where categoria.nome = categoria_nome;
    if contador > 0 then
        set categoria_possui_livros = true;
    else
        set categoria_possui_livros = false;
    end if;
end; 
//

-- 5
delimiter //
create procedure sp_livrosateano(in p_ano_publicacao int)
begin
    select titulo
    from livro
    where ano_publicacao <= p_ano_publicacao;
end;
//
delimiter ;

call sp_livrosateano(2007);
-- 2007 pra homenagear o ano que eu nasci né! kkkkkk
delimiter ;

call sp_verificar_livros_categoria('História', @possui_livros);
select @possui_livros ;

-- 6
delimiter //
create procedure sp_titulos_por_categoria(in categoria_nome varchar(100))
begin
    select livro.titulo
    from livro
    inner join categoria on livro.categoria_id = categoria.categoria_id
    where categoria.nome = categoria_nome;
end;
//
delimiter ;

call sp_titulos_por_categoria('História');

-- 7 
delimiter //
create procedure sp_adicionarlivro(
    in p_titulo varchar(255),
    in p_editora_id int,
    in p_ano_publicacao int,
    in p_numero_paginas int,
    in p_categoria_id int,
    out p_resultado varchar(255)
)
begin
    declare livro_existente int;
    
    select count(*) into livro_existente
    from livro
    where titulo = p_titulo;
    
    if livro_existente > 0 then
        set p_resultado = 'Esse título de livro já existe na bibliotecaaa <3';
    else
        insert into livro (titulo, editora_id, ano_publicacao, numero_paginas, categoria_id)
        values (p_titulo, p_editora_id, p_ano_publicacao, p_numero_paginas, p_categoria_id);
        
        set p_resultado = 'O livro foi adicionado com sucessooo <3';
    end if;
end;
//
delimiter ;

call sp_adicionarlivro('Livro Novo! Ebaaa', 1, 2023, 350, 2, @resultado);
select @resultado;

-- 8
delimiter //
create procedure sp_autor_mais_antigo()
begin
    select concat(nome, ' ', sobrenome) as nome_autor
    from autor
    where data_nascimento = (
        select min(data_nascimento)
        from autor
    );
end;
//
delimiter ;

call sp_autor_mais_antigo();

-- 9
-- aqui estamos definindo um novo delimitador para evitar conflito com o ponto e vírgula.
delimiter //

-- aqui estamos criando a procedure chamada sp_livrosateano com um parâmetro de entrada p_ano_publicacao.
create procedure sp_livrosateano(in p_ano_publicacao int)

-- logo abaixo teremos o begin, indicando o início do bloco de código da stored procedure
begin
    -- aqui estamos selecionando o título dos livros da tabela livro
    select titulo
    from livro
    -- ... onde o ano de publicação seja menor ou igual ao ano fornecido como parâmetro, que mais pra frente será mostrado.
    where ano_publicacao <= p_ano_publicacao;
end;
-- logo acima temos o end, que marca o final do bloco de código da stored procedure.
//
-- restaurar o delimitador padrão para ponto e vírgula.
delimiter ;

-- chamar a stored procedure sp_livrosateano com o ano 2007 como argumento.
call sp_livrosateano(2007);

-- ao final, esse exercício permite que a stored procedure sp_livrosateano...
-- ...retorne os títulos dos livros publicados até o ano especificado quando é...
-- ...chamada com um ano como argumento, como no exemplo call sp_livrosateano(2007); que é um parâmetro.
